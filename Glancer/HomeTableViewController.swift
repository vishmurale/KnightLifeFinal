//
//  HomeTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 11/29/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var timer = NSTimer();
    
    @IBOutlet weak var mainDayLabel: UILabel!
    @IBOutlet weak var mainBlockLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    @IBOutlet weak var mainNextBlockLabel: UILabel!
    
    var dayNum: Int = 0
    var numOfRows: Int = 0
    var row: Int = 0
    var minutesUntilNextBlock: Int = 0
    var labels: [Label] = []
    var cell: BlockTableViewCell = BlockTableViewCell()
    
    var labelsGenerated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.update()

        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "doEverything", userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent //status bar is white
    }
    
    
    func doEverything() {
   
        
        print("setting up home page...")
        
        if (appDelegate.Days.count > 0){
 
            updateMainHomePage()

            
            if dayNum < 5 {
                checkSecondLunch()
            }
          
            
            generateLabels()
            getNumOfRows()
            
            self.tableView.reloadData()
            
            timer.invalidate()
        }
        
    }
    
    func updateMainHomePage() {
        //updates the main labels on home page
      
       
        mainDayLabel.text = getMainDayLabel()
        
        mainBlockLabel.text = getMainBlockLabel()
        
        
        
        mainTimeLabel.text = getMainTimeLabel()
        
        
        
        mainNextBlockLabel.text = getMainNextBlockLabel()
     
        
    }
    
    
    //GETTING HOME PAGE LABELS
    func getMainDayLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        self.dayNum = Day_Num
        if dayNum == 5 {
            return "Saturday"
        } else if dayNum == 6 {
            return "Sunday"
        } else {
            return appDelegate.Days[Day_Num].name
        }
    }
    
    func getMainBlockLabel() -> String {
        
        
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        
        if Day_Num < 5 {
            
            let currentValues = CurrentDayandStuff()
            
            let currentBlock = currentValues.current_block
            let currentClass = appDelegate.Days[Day_Num].messages_forBlock[currentBlock]
            if currentClass != nil {
                return "\(currentBlock) Block (\(currentClass!))"
            } else if currentBlock == "GetToClass" {
                return "Class Over"
            }
            else if currentBlock == "BeforeSchoolGetToClass"{
                
                return "School Begins"
                
            }
            else {
                return ""
            }
        } else {
            return ""
        }
        
    }
    
    func getMainTimeLabel() -> String {
        
       
        
        
        let currentDateTime = appDelegate.Days[0].getDate_AsString()

        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        
        
        if Day_Num < 5 {
            
            
            let currentValues = CurrentDayandStuff()
            let currentBlock = currentValues.current_block
            let currentClass = appDelegate.Days[Day_Num].messages_forBlock[currentBlock]
            if currentClass != nil {
                let minutesRemaining = currentValues.minutesRemaining
                return "\(minutesRemaining) mins remaining"
            } else if currentBlock == "GetToClass" ||  currentBlock == "BeforeSchoolGetToClass"{
                let minutesRemaining = currentValues.minutesRemaining
                let minutesUntil = 5 - (-minutesRemaining)
                return "\(minutesUntil) mins until"
            } else if currentBlock == "BeforeSchool"{

                return "Before School"
                
            }else{
                
                return "School Over"
            }
        } else {
            return "No School"
        }
    }
    
    func getMainNextBlockLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        
        if Day_Num < 5 {
            let currentValues = CurrentDayandStuff()
            let currentBlock = currentValues.current_block
            let nextBlock = currentValues.next_block
            let nextClass = appDelegate.Days[Day_Num].messages_forBlock[nextBlock]
            if nextClass != nil {
                return "Next: \(nextBlock) Block (\(nextClass!))"
            } else if currentBlock == "GetToClass" {
                return "Next Block"
            } else {
                return ""
            }
        } else {
            return ""
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
    
    
    //CREATE TABLE
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.numOfRows
    }
    
    func getNumOfRows() {
        //finds number of rows in table
        numOfRows = labels.count
            
        print("Rows Updated")
        print("")
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //creates cells
        if (appDelegate.Days.count > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BlockTableViewCell
            let label = labels[indexPath.row]
            cell.label = label
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BlockTableViewCell
            let label = Label(bL: "", cN: "", cT: "")
            cell.label = label
            
            return cell
        }
        
    }
    
    
    func generateLabels() {
        //generates array of information for each cell
        if !labelsGenerated {
            if dayNum < 5 {
                
                for (index, time) in appDelegate.Days[dayNum].ordered_times.enumerate(){
                    
                    print("home view controller is running");
                    
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
        
    }
   
    
    
    
    func find_Minutes(hour_before : Int, hour_after : Int)->Int{
        
        
        let num_hours_less = Int(hour_before/100)
        let num_hours_more = Int(hour_after/100)
        
        let diff_hours = num_hours_more-num_hours_less
        
        print("Diff in hours" + String(diff_hours))
        
        let diff_minutes = hour_after%100 - hour_before%100
        
        print("Diff in minutes" + String(diff_minutes))
        
        
        return diff_hours*60 + diff_minutes;
        
        
    }
    
    
    
    func CurrentDayandStuff() -> (current_block : String, next_block : String, minutesRemaining : Int){
        
        
        let currentDateTime = appDelegate.Days[0].getDate_AsString()
        let Day_Num = appDelegate.Days[0].getDayOfWeek_fromString(currentDateTime)
        
        
        var Widget_Block = appDelegate.Widget_Block;
        var Time_Block = appDelegate.Time_Block;
        var End_Times = appDelegate.End_Times;
        var End_Times_Block = appDelegate.End_Time_Block
        
        var Curr_block = ""
        var next_block = ""
        
        print("ayoo")
        print(Day_Num)
        var minutes_until_nextblock = 0;
        
        //NEW STUFF get's info for the first lunch data for today
        
       let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
        
        var firstLunch_temp = true;
        
        if(defaults!.objectForKey("SwitchValues") != nil){
            let UserSwitch: [Bool] = defaults!.objectForKey("SwitchValues") as! Array<Bool>
            firstLunch_temp = UserSwitch[Day_Num]
        }

        if(!firstLunch_temp){
            
            print("they have second lunch today, run a different schedule")
            
            let time_of_secondLunch = appDelegate.Second_Lunch_Start[Day_Num];
            
            var counter = 0;
            
            for x in Widget_Block[Day_Num]{
                
                
                if(x.hasSuffix("2")){
                    
                    Time_Block[Day_Num][counter] = time_of_secondLunch;
                    End_Times_Block[Day_Num][counter-1] = time_of_secondLunch
                    
                }
                
                
                counter++;
                
            }
            
            print("New Time schedule");
            print(Time_Block[Day_Num]); //also need to change end times
            
        }
        //NEW STUFF
        
        for i in Array((0...Widget_Block[Day_Num].count-1).reverse()){

            
            let dateAfter = Time_Block[Day_Num][i]
            let CurrTime = appDelegate.Days[0].NSDateToStringWidget(NSDate())
         //   var CurrTime = "-07-55";
            
          
            var End_Time_String = End_Times_Block[Day_Num][i];

            print("End_Time_String " + End_Time_String);
            
            
            print("Date After : " + dateAfter)
            print("Current Date : " + CurrTime)
            
            var hour4 = self.substring(dateAfter,StartIndex: 1,EndIndex: 3)
            hour4 = hour4 + self.substring(dateAfter,StartIndex: 4,EndIndex: 6)
            
            var hour2 = self.substring(CurrTime,StartIndex: 1,EndIndex: 3)
            hour2 = hour2 + self.substring(CurrTime,StartIndex: 4,EndIndex: 6)
            
            var end_time = self.substring(End_Time_String,StartIndex: 1,EndIndex: 3)
            end_time = end_time + self.substring(End_Time_String,StartIndex: 4,EndIndex: 6)
            
            
            let hour_one = Int(hour4)
            let hour_two = Int(hour2)
            let hour_after = Int(end_time)
            
            
            print("Blcok  Date  hour : ")
            print(hour_one, terminator: "")
            print("Current Date hour: ")
            print(hour_two, terminator: "")
            print("After Date  hour : ")
            print(hour_after)
            
            //check if before school
            if(i==0 && hour_two < hour_one ){
                
                 print("IN HEERE");
                
                 Curr_block = "BeforeSchool"
                 next_block = Widget_Block[Day_Num][i]
                
                
                 minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (hour_one!))
                                  print("minutes" + String(minutes_until_nextblock))
                
                
                if(minutes_until_nextblock <= 5){
                    
                    minutes_until_nextblock = -5+minutes_until_nextblock;
                    Curr_block = "BeforeSchoolGetToClass"
                    next_block = Widget_Block[Day_Num][i]
                    
                    
                }
                
                
                
                
            }
            
            
            
            
            //last block
            if(i == Widget_Block[Day_Num].count-1 && hour_two >= hour_one){
                
                let EndTime = End_Times[Day_Num]
                if(hour_two! - EndTime < 0){
                    
                    
                    minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (EndTime))
                    
                    print("Miuntes until next blok " + String(minutes_until_nextblock))
                    if(minutes_until_nextblock > 0){
                        Curr_block = Widget_Block[Day_Num][i]
                        next_block = "No Class"
                    }
                    else {
                        Curr_block = "GetToClass"
                        next_block = Widget_Block[Day_Num][i]
                    }
                }
                else{
                    print("After School")
                    Curr_block = "NOCLASSNOW"
                    next_block = "No Class"

                }
                
                break;
                
            }
            

            if(hour_two >= hour_one){
                
                
                minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (hour_after!))
                
                print("Miuntes unitl next block " + String(minutes_until_nextblock))
                
                if(minutes_until_nextblock > 0){
                    
                    Curr_block = Widget_Block[Day_Num][i]
                    
                    next_block = Widget_Block[Day_Num][i + 1]
                }
                else{
                    Curr_block = "GetToClass"
                    next_block = Widget_Block[Day_Num][i + 1]

                }
                
                break;
            }
            
        }
     
        
        return (Curr_block, next_block, minutes_until_nextblock);
        
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
    
}
