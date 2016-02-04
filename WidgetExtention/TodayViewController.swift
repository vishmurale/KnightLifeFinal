//
//  TodayViewController.swift
//  WidgetExtention
//
//  Created by Vishnu Murale on 6/9/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit
import NotificationCenter
import Parse


class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    
    var timer = NSTimer();
    
    let BlockOrder = ["A","B","C","D","E","F","G"]
    
    
    var Schedule = PFObject(className:"Schedule")
    let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenWidth = screenSize.width
        
        self.preferredContentSize = CGSizeMake(screenWidth, 300);
        
        
        //parse goes here
        
        
        self.update_widget()
        
        
    }
    
  
    
    
    func SetTextForOtherBlocks(Day_Num : Int, Days :[Day], firstLunch : Bool, User_Info : [String]) -> String{
        
        var text = "";
        
        for block in Days[Day_Num].ordered_blocks{
            
            var message = block;
            
            if(firstLunch && message.hasSuffix("1")){
                
                
                message = "Lunch"
                
                
                
            }
            else if(!firstLunch && message.hasSuffix("2")){
                
                message = "Lunch"
                
                
            }else{
                
                var counterDigit = 0;
                
                
                for i in message.characters{
                    
                    
                    if(message.characters.count > 2 && String(i) == "A" && counterDigit == 0){
                        counterDigit++;
                        message = "Act"
                        
                    }else{
                        
                        if(counterDigit == 0){
                            message = String(i)
                        }
                        counterDigit++;
                    }
                    
                }
                
                
                
                
                
                
            }
            
            
            if(self.BlockOrder.indexOf(message) != nil){
                
                let indexOfUserInfo = self.BlockOrder.indexOf(message)!
                
                if(User_Info[indexOfUserInfo] != ""){
                    message = User_Info[indexOfUserInfo]
                    
                }
                
                
                
                
            }
            
            
            
            
            text += message + " ";
            
            
        }
        
        
        return text;
        
        
        
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
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        
    }
    
    
    
    
    func getBlockAfter(curr_index : Int, Blocks :[Array<String>], daynum : Int, firstLunch : Bool, User_Info : [String] ) -> String{
        
        
        
        if(curr_index == -2){
            
            return " "
            
        }
        
        if((curr_index + 1) < Blocks[daynum].count){
            
            
            
            var block_copy =  Blocks[daynum][curr_index + 1];
            var message = block_copy;
            
            if(block_copy.characters.count == 2) {
                
                if(firstLunch && block_copy.hasSuffix("1")){
                    
                    
                    message = "Lunch"
                    
                    
                    
                }
                else if(!firstLunch && block_copy.hasSuffix("2")){
                    
                    message = "Lunch"
                    
                    
                }
                else{
                    
                    
                    
                    
                    
                    
                    
                    
                    var counterDigit = 0;
                    
                    for i in block_copy.characters{
                        
                        if(counterDigit == 0){
                            block_copy = String(i)
                        }
                        
                        counterDigit++;
                        
                    }
                    
                    
                    
                }
            }
            
            
            
            if(self.BlockOrder.indexOf(block_copy) != nil){
                
                let indexOfUserInfo = self.BlockOrder.indexOf(block_copy)!
                
                if(User_Info[indexOfUserInfo] != ""){
                    message = User_Info[indexOfUserInfo]
                    
                }
                
                
                
                
            }
            
            
            
            return message;
            
            
            
        }else{
            
            return "End of School";
            
        }
        
        
        
        
    }
    
    func update_widget() -> Bool{
        
        
        
        
        let screenWidth = screenSize.width
        
        
        let Block_After = UILabel(frame: CGRectMake(0, 0, 500, 21))
        Block_After.center = CGPointMake(screenWidth/2-100/2, 284)
        Block_After.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        Block_After.adjustsFontSizeToFitWidth = true
        Block_After.textAlignment = NSTextAlignment.Center
        self.view.addSubview(Block_After);
        
        
        let Time_Label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        Time_Label.center = CGPointMake(screenWidth/2-100/2, 200)
        Time_Label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        Time_Label.textAlignment = NSTextAlignment.Center
        Time_Label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(Time_Label);
        
        let Block_Label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        Block_Label.center = CGPointMake(screenWidth/2-100/2, 100)
        Block_Label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        Block_Label.textAlignment = NSTextAlignment.Center
        Block_Label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(Block_Label);
        
        
        var Success = false;
        
        var Days = [Day]()
        
        
        let query = PFQuery(className:"Schedule")
        
        
        
        
        
        query.getObjectInBackgroundWithId("JpYQ5LEoRs")
            {
                (SchedObj: PFObject?, error: NSError?) -> Void in
                if error == nil && SchedObj != nil {
                    var Widget_Block = [Array<String>]()
                    var Time_Block = [Array<String>]()
                    var End_Time_Block = [Array<String>]();
                    
                    
                    Widget_Block.removeAll()
                    Time_Block.removeAll()
                    End_Time_Block.removeAll()
                    
                    
                    print("Retrived Information Successful")
                    
                    
                    
                    self.Schedule = SchedObj!
                    print(self.Schedule, terminator: "")
                    let Monday = Day(name:"Monday")
                    let Tuesday = Day(name:"Tuesday")
                    let Wednesday = Day(name:"Wednesday")
                    let Thursday = Day(name:"Thursday")
                    let Friday = Day(name:"Friday")
                    
                    
                    if(self.Schedule["MB"] != nil && self.Schedule["MST"] != nil && self.Schedule["MET"] != nil){
                        let bO: Array<String> = self.Schedule["MB"] as! Array<String>
                        let t: Array<String> = self.Schedule["MST"] as! Array<String>
                        let Et: Array<String> = self.Schedule["MET"] as! Array<String>
                        
                        
                        End_Time_Block.append(Et);
                        
                        Widget_Block.append(bO)
                        Time_Block.append(t)
                        Monday.refreshDay(bO, times: t)
                    }
                    
                    if(self.Schedule["TB"] != nil && self.Schedule["TST"] != nil && self.Schedule["TET"] != nil){
                        let bO: Array<String> = self.Schedule["TB"] as! Array<String>
                        let t: Array<String> = self.Schedule["TST"] as! Array<String>
                        
                        let Et: Array<String> = self.Schedule["TET"] as! Array<String>
                        
                        
                        End_Time_Block.append(Et);
                        
                        
                        Widget_Block.append(bO)
                        Time_Block.append(t)
                        Tuesday.refreshDay(bO, times: t)
                    }
                    
                    if(self.Schedule["WB"] != nil && self.Schedule["WST"] != nil && self.Schedule["WET"] != nil){
                        let bO: Array<String> = self.Schedule["WB"] as! Array<String>
                        let t: Array<String> = self.Schedule["WST"] as! Array<String>
                        
                        let Et: Array<String> = self.Schedule["WET"] as! Array<String>
                        
                        
                        End_Time_Block.append(Et);
                        
                        Widget_Block.append(bO)
                        Time_Block.append(t)
                        Wednesday.refreshDay(bO, times: t)
                    }
                    
                    if(self.Schedule["ThB"] != nil && self.Schedule["ThST"] != nil && self.Schedule["ThET"] != nil){
                        let bO: Array<String> = self.Schedule["ThB"] as! Array<String>
                        let t: Array<String> = self.Schedule["ThST"] as! Array<String>
                        
                        let Et: Array<String> = self.Schedule["ThET"] as! Array<String>
                        
                        
                        End_Time_Block.append(Et);
                        
                        
                        Widget_Block.append(bO)
                        Time_Block.append(t)
                        Thursday.refreshDay(bO, times: t)
                    }
                    
                    if(self.Schedule["FB"] != nil && self.Schedule["FST"] != nil && self.Schedule["FET"] != nil){
                        let bO: Array<String> = self.Schedule["FB"] as! Array<String>
                        let t: Array<String> = self.Schedule["FST"] as! Array<String>
                        
                        let Et: Array<String> = self.Schedule["FET"] as! Array<String>
                        
                        
                        End_Time_Block.append(Et);
                        
                        
                        Widget_Block.append(bO)
                        Time_Block.append(t)
                        Friday.refreshDay(bO, times: t)
                    }
                    
                    

                    
                    Days.append(Monday)
                    Days.append(Tuesday)
                    Days.append(Wednesday)
                    Days.append(Thursday)
                    Days.append(Friday)
                    let currentDateTime = Monday.getDate_AsString()
                    
                    
                    
                    //rember it shouldn't always be monday
                    
                    let Day_Num = Monday.getDayOfWeek_fromString(currentDateTime)
                    
                    // let Day_Num = 0; seems to have worked
                    
                    
                    
                    var User_Info = [String]()
                    
                    
                    
                    
                    if(self.defaults!.objectForKey("ButtonTexts") != nil){
                        User_Info = self.defaults!.objectForKey("ButtonTexts") as! Array<String>
                    }
                    var Switch_Info = [Bool]()
                    if(self.defaults!.objectForKey("SwitchValues") != nil){
                        Switch_Info = self.defaults!.objectForKey("SwitchValues") as! Array<Bool>
                    }
                    print("")
                    print("Finding Widget Date ...")
                    
                    
                    var End_Times = [Int]()
                   
                    
                    if(self.Schedule["SchoolET"] != nil){
                        End_Times = self.Schedule["SchoolET"] as! Array<Int>
                    }
                    
                    
                    
                    
                   
                   
                    
                    var minutes_until_nextblock = 0;
                    var blockName_Widget = " "
                    
                    var Second_Lunch_Start = Array<String>();
                    
                    if(self.Schedule["SecondLunchST"] != nil){ //pulls info from parse for second lunch info
                        Second_Lunch_Start = self.Schedule["SecondLunchST"]  as! Array<String>
                    }
                    
                    
                    
                    
                    
                    var index_of_current_block = -2;
                    
                    
                    
                    if(Day_Num >= 0 && Day_Num <= 4){
                        
                        
                        let firstLunch_temp = Switch_Info[Day_Num]
                        
                        
                        
                        
                        if(!firstLunch_temp){ //aka second lunch
                            
                            print("they have second lunch today, run a different schedule")
                            
                            var time_of_secondLunch = Second_Lunch_Start[Day_Num];
                            
                            var counter = 0;
                            
                            for x in Widget_Block[Day_Num]{
                                
                                
                                if(x.hasSuffix("2")){
                                    
                                    Time_Block[Day_Num][counter] = time_of_secondLunch;
                                    End_Time_Block[Day_Num][counter-1] = time_of_secondLunch

                                    
                                }
                                
                                
                                
                                counter++;
                                
                            }
                            
                            print("new time schedule");
                            print(Time_Block[Day_Num]);
                            
                        }
                        
                        
                        
                        
                        
                        for i in Array((0...Widget_Block[Day_Num].count-1).reverse()){
                            
                            
                            
                            
                            
                            
                            let dateAfter = Time_Block[Day_Num][i]
                            let CurrTime = Monday.NSDateToStringWidget(NSDate())
                            
                            
                            var End_Time_String = End_Time_Block[Day_Num][i];
                            
                            
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
                            
                            
                            
                            if(i==0 && hour_two < hour_one ){
                                
                                print("IN HEERE");
                                
                                
                                blockName_Widget = "BeforeSchool"
                                index_of_current_block = -1;
                                

                                
                                
                                minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (hour_one!))
                                print("minutes" + String(minutes_until_nextblock))
                                
                                
                                if(minutes_until_nextblock <= 5){
                                    
                                    blockName_Widget = "GETTOCLASS"
                                    index_of_current_block = -1;
                                    
                                }
                                
                                
                                
                                
                            }
                            
                            
                            if(i == Widget_Block[Day_Num].count-1 && hour_two >= hour_one){
                                
                                let EndTime = End_Times[Day_Num]
                                if(hour_two! - EndTime < 0){
                                    
                                    
                                    minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (EndTime))
                                    
                                    print("Miuntes until next blok " + String(minutes_until_nextblock))
                                    
                                    if(minutes_until_nextblock > 0){
                                        
                                        index_of_current_block = i;
                                        blockName_Widget = Widget_Block[Day_Num][i]
                                    }
                                    else{
                                        index_of_current_block = i;
                                        blockName_Widget = "GETTOCLASS"
                                    }
                                }
                                else{
                                    print("After School")
                                    blockName_Widget = "NOCLASSNOW"
                                }
                                
                                break;
                                
                            }
                            
                            
                            if(hour_two >= hour_one){
                                
                                
                                minutes_until_nextblock = self.find_Minutes(hour_two!, hour_after: (hour_after!))
                                
                                print("Miuntes unitl next block " + String(minutes_until_nextblock))
                                
                                if(minutes_until_nextblock > 0){
                                    index_of_current_block = i;
                                    blockName_Widget = Widget_Block[Day_Num][i]
                                    
                                }
                                else{
                                    
                                    index_of_current_block = i;
                                    blockName_Widget = "GETTOCLASS"
                                }
                                
                                break;
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    if(blockName_Widget == " "){
                        
                        blockName_Widget = "NOCLASSNOW"
                        
                    }
                    
                    
                    
                    print("Found the block name Widget " + blockName_Widget )
                    
                    if(blockName_Widget == "NOCLASSNOW"){
                        Block_Label.text = "No Class Now"
                        
                        
                        
                        print("NO Class Now")
                        
                        
                    }else if(blockName_Widget == "BeforeSchool"){
                        Block_Label.text = "Before School"
                        
                        let firstLunch = Switch_Info[Day_Num]
                        
                        let text  = self.getBlockAfter(index_of_current_block, Blocks: Widget_Block, daynum: Day_Num, firstLunch: firstLunch, User_Info:  User_Info);
                        
                         print("Before School")
                        
                        print("After block " + text);
                        
                        Block_After.text = "After : " + text;
                        
                    }
                    else if(blockName_Widget == "GETTOCLASS"){
                        Block_Label.text = "Passing Time"
                        
                        print("Passing Time")
                        
                        let firstLunch = Switch_Info[Day_Num]
                        
                        let text  = self.getBlockAfter(index_of_current_block, Blocks: Widget_Block, daynum: Day_Num, firstLunch: firstLunch, User_Info:  User_Info);
                        
                        print("After block " + text);
                        
                        Block_After.text = "After : " + text;
                        
                        
                        
                    }
                    else{
                        
                        let firstLunch = Switch_Info[Day_Num]
                        
                        
                        let text  = self.getBlockAfter(index_of_current_block, Blocks: Widget_Block, daynum: Day_Num, firstLunch: firstLunch, User_Info:  User_Info);
                        
                        
                        //   let text = self.SetTextForOtherBlocks(Day_Num, Days: Days, firstLunch: firstLunch, User_Info: User_Info);
                        
                        print("After block " + text);
                        
                        
                        
                        for (date,block) in Days[Day_Num].time_to_block{
                            var message = block;
                            var block_copy = block;
                            
                            
                            
                            
                            
                            if(block_copy.characters.count == 2) {
                                
                                if(firstLunch && block_copy.hasSuffix("1")){
                                    
                                    
                                    message = "Lunch"
                                    
                                    
                                    
                                }
                                else if(!firstLunch && block_copy.hasSuffix("2")){
                                    
                                    message = "Lunch"
                                    
                                    
                                }
                                else{
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    var counterDigit = 0;
                                    
                                    for i in block_copy.characters{
                                        
                                        if(counterDigit == 0){
                                            block_copy = String(i)
                                        }
                                        
                                        counterDigit++;
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                            
                            
                            if(self.BlockOrder.indexOf(block_copy) != nil){
                                
                                let indexOfUserInfo = self.BlockOrder.indexOf(block_copy)!
                                
                                if(User_Info[indexOfUserInfo] != ""){
                                    message = User_Info[indexOfUserInfo]
                                    
                                }
                                
                                
                                
                                
                            }
                            
                            
                            if(block == blockName_Widget){
                                print("have found widget block " + block)
                                print("Message on Widget " + message)
                                print("In Extension")
                                Block_Label.text = "Current Block : " + message
                                
                                
                                Time_Label.text = "Minutes Left : " + String(minutes_until_nextblock)
                                
                                
                                
                                Block_After.text = "After : " + text;
                                
                                break;
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                    Success = true;
                    
                    
                    
                    
                    
                } else {
                    
                    
                    print("Information not received succesfully")
                }
        }
        
        
        
        return Success
    }
    
    
}
