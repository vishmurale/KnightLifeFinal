//
//  WeekTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 12/30/15.
//  Copyright © 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class WeekTableViewController: UITableViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var timer = NSTimer();
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var labelsGenerated: Bool = false
    
    var dayNum: Int = 0
    var numOfRows: Int = 0
    var row: Int = 0
    var labels: [Label] = []
    var cell: BlockTableViewCell = BlockTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.update()
        
       
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)
    }


    
    //MAKING STATUS BAR WHITE
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func segControlChanged(sender: AnyObject) {
        self.dayNum = segControl.selectedSegmentIndex
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)
    }//hi
    
    func doEverything() {
        
        print("setting up week page...")
        
        if (appDelegate.Days.count > 0){
            
            labels = []
            labelsGenerated = false
            checkSecondLunch()
            generateLabels()
            getNumOfRows()
            
          
            
            
            self.tableView.reloadData()
            
            timer.invalidate()
        }
        
    }
    
    func checkSecondLunch() {
        
        //NEW STUFF get's info for the first lunch data for today
        let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
        var firstLunch_temp: Bool = true
        if defaults!.objectForKey("SwitchValues") != nil {
            let UserSwitch: [Bool] = defaults!.objectForKey("SwitchValues") as! Array<Bool>
            firstLunch_temp = UserSwitch[dayNum]
        }
        //NEW STUFF
        
        
        //NEW STUFF
        //we change the time's array to reflect the second lunch if they have second lunch
        if(!firstLunch_temp) { //aka second lunch
            
            print("they have second lunch today, run a different schedule")
            
            let time_of_secondLunch = appDelegate.Second_Lunch_Start[dayNum];
            
            appDelegate.Days[dayNum].ordered_times[5] = time_of_secondLunch
            appDelegate.End_Time_Block[dayNum][4] = time_of_secondLunch
            
            /*
            var counter = 0;
            var Widget_Block = appDelegate.Widget_Block;
            var Time_Block = appDelegate.Time_Block;
            
            for x in Widget_Block[dayNum]{
                
                
                if(x.hasSuffix("2")){
                    
                    Time_Block[dayNum][counter] = time_of_secondLunch;
                    
                }
                
                
                
                counter++;
                
                
            }
            */
        }
    }
    
    
    func generateLabels() {
        
        if !labelsGenerated {
            
            print("Week view controller is running");
            

            
            
            for (index, time) in appDelegate.Days[dayNum].ordered_times.enumerate(){
                
                print("index ")
                print(index);
                
                var blockLetter = ""
                let blockName = appDelegate.Days[dayNum].ordered_blocks[index];
                if blockName == "Lab" {
                    blockLetter = "\(appDelegate.Days[dayNum].ordered_blocks[index - 1])L"
                } else if blockName == "Activities" {
                    blockLetter = "Ac"
                } else {
                    blockLetter = blockName
                }
                
                var classLabel = ""
                let className = appDelegate.Days[dayNum].messages_forBlock[blockName];
                if className == blockLetter {
                    classLabel = "\(blockName) Block"
                } else if blockName == "Lab" {
                    classLabel = "\(appDelegate.Days[dayNum].ordered_blocks[index - 1]) Lab"
                } else {
                    classLabel = className!
                }
                
                
                //time is in the form of string, in military time, so the following converts it to a regular looking time
                
                
                let end_time = substring(appDelegate.End_Time_Block[dayNum][index], StartIndex: 1, EndIndex: 3)
                
                
                
                
                var end_time_num:Int! = Int(end_time);
                if(end_time_num > 12){
                    end_time_num = end_time_num! - 12;
                }
                
                let regular_hours_end:String! = String(end_time_num);
                
                let minutes_end = substring(appDelegate.End_Time_Block[dayNum][index],StartIndex: 4,EndIndex: 6)
                
                print(appDelegate.End_Time_Block[dayNum][index]);
                print(minutes_end)

                
                
                let end_time_fin = regular_hours_end + ":" + minutes_end

                
                
                let hours = substring(time, StartIndex: 1, EndIndex: 3)
                var hours_num:Int! = Int(hours);
                if(hours_num > 12){
                    hours_num = hours_num! - 12;
                }
                let regular_hours:String! = String(hours_num);
                let minutes = substring(time,StartIndex: 4,EndIndex: 6)
                let start_time = regular_hours + ":" + minutes
                
                
                let time = start_time + " - " + end_time_fin;
                
                //converting is ended "final_time" is the correct time
                
                let newLabel = Label(bL: blockLetter, cN: classLabel, cT: time)
                labels.append(newLabel)
                
                print(blockLetter + " " + classLabel + " " + time + " ")
                print("")
            }
            
            self.labelsGenerated = true
            
        }
        
    }
    
    func getNumOfRows() {
        
        numOfRows = labels.count
        
        print("Rows Updated")
        print("")
        
    }
    
    func substring(origin :String, StartIndex : Int, EndIndex : Int)->String{
        var counter = 0
        var subString = ""
        for char in origin.characters{
            
            if(StartIndex <= counter && counter < EndIndex){
                subString += String(char)
            }
            
            counter++;
            
        }
        
        return subString
        
    }



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.numOfRows
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (appDelegate.Days.count > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Block2TableViewCell
            let label = labels[indexPath.row]
            cell.label = label
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Block2TableViewCell
            let label = Label(bL: "", cN: "", cT: "")
            cell.label = label
            
            return cell
        }
        
    }


    

}
