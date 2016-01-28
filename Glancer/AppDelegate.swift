//
//  AppDelegate.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit
import Parse



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let BlockOrder = ["A","B","C","D","E","F","G"]
    
    var End_Times = [Int]();
    
    //NEW STUFF
    var Second_Lunch_Start = Array<String>(); //this array holds the second lunch start times monday-fri
    //NEW STUFF
    
    var Days = [Day]()
    var Id : String = ""
    var MondayExists = false
    var Timer = NSTimer();
    var Widget_Block = [Array<String>]();
    var Time_Block = [Array<String>]();
    var End_Time_Block = [Array<String>]();
    var pushNotificationController:PushNotificationController?
    var Schedule = PFObject(className:"Schedule")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)
        
        
        self.pushNotificationController = PushNotificationController()
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = ([.Alert, .Badge, .Sound])
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        
        //Query Parse For Monday-Friday Schedules
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("failed to register for remote notifications:  (error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }
    
    
    
    func update() -> Bool{
        
        var Success = false;
        
        Days.removeAll()
        
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("Everyone", forKey: "channels")
        currentInstallation.saveInBackground()
        
        
        let query = PFQuery(className:"Schedule")
        
        
        query.getObjectInBackgroundWithId("JpYQ5LEoRs")
            {
                
                (SchedObj: PFObject?, error: NSError?) -> Void in
                if error == nil && SchedObj != nil {
              
                    self.Schedule = SchedObj!
                    
                    let app:UIApplication = UIApplication.sharedApplication()
                    for Event in app.scheduledLocalNotifications! {
                        var notification = Event as! UILocalNotification
                        app.cancelLocalNotification(notification)
                    }
                    
                    
                    if(self.Schedule["push"] != nil){
                        
                        var show : Bool = self.Schedule["push"] as! Bool
                        
                        if(show){
                            
                            
                            
                            self.Widget_Block.removeAll()
                            self.Time_Block.removeAll()
                            self.End_Time_Block.removeAll()
                            
                            print("Retrived Information Successful")
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
                                
                                
                                self.End_Time_Block.append(Et);
                                
                                self.Widget_Block.append(bO)
                                self.Time_Block.append(t)
                                Monday.refreshDay(bO, times: t)
                            }
                            
                            if(self.Schedule["TB"] != nil && self.Schedule["TST"] != nil && self.Schedule["TET"] != nil){
                                let bO: Array<String> = self.Schedule["TB"] as! Array<String>
                                let t: Array<String> = self.Schedule["TST"] as! Array<String>
                                
                                let Et: Array<String> = self.Schedule["TET"] as! Array<String>
                                
                                
                                self.End_Time_Block.append(Et);
                                
                                
                                self.Widget_Block.append(bO)
                                self.Time_Block.append(t)
                                Tuesday.refreshDay(bO, times: t)
                            }
                            
                            if(self.Schedule["WB"] != nil && self.Schedule["WST"] != nil && self.Schedule["WET"] != nil){
                                let bO: Array<String> = self.Schedule["WB"] as! Array<String>
                                let t: Array<String> = self.Schedule["WST"] as! Array<String>
                                
                                let Et: Array<String> = self.Schedule["WET"] as! Array<String>
                                
                                
                                self.End_Time_Block.append(Et);
                                
                                self.Widget_Block.append(bO)
                                self.Time_Block.append(t)
                                Wednesday.refreshDay(bO, times: t)
                            }
                            
                            if(self.Schedule["ThB"] != nil && self.Schedule["ThST"] != nil && self.Schedule["ThET"] != nil){
                                let bO: Array<String> = self.Schedule["ThB"] as! Array<String>
                                let t: Array<String> = self.Schedule["ThST"] as! Array<String>
                                
                                let Et: Array<String> = self.Schedule["ThET"] as! Array<String>
                                
                                
                                self.End_Time_Block.append(Et);
                                
                                
                                self.Widget_Block.append(bO)
                                self.Time_Block.append(t)
                                Thursday.refreshDay(bO, times: t)
                            }
                            
                            if(self.Schedule["FB"] != nil && self.Schedule["FST"] != nil && self.Schedule["FET"] != nil){
                                let bO: Array<String> = self.Schedule["FB"] as! Array<String>
                                let t: Array<String> = self.Schedule["FST"] as! Array<String>
                                
                                let Et: Array<String> = self.Schedule["FET"] as! Array<String>
                                
                                
                                self.End_Time_Block.append(Et);
                                
                                
                                self.Widget_Block.append(bO)
                                self.Time_Block.append(t)
                                Friday.refreshDay(bO, times: t)
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            self.Days.append(Monday)
                            self.Days.append(Tuesday)
                            self.Days.append(Wednesday)
                            self.Days.append(Thursday)
                            self.Days.append(Friday)
                            
                            
                            
                            if(self.Schedule["SchoolET"] != nil){
                                self.End_Times = self.Schedule["SchoolET"] as! Array<Int>
                            }
                            
                            
                            
                            
                            //NEW STUFF
                            if(self.Schedule["SecondLunchST"] != nil){ //pulls info from parse for second lunch info
                                self.Second_Lunch_Start = self.Schedule["SecondLunchST"]  as! Array<String>
                            }
                            //NEW STUFF
                            
                            
                            
                            
                            
                            
                            let currentDateTime = Monday.getDate_AsString()
                            let Day_Num = Monday.getDayOfWeek_fromString(currentDateTime)
                            
                            var index : Double = 0;
                            index = -Double(Day_Num);
                            
                            
                            /*
                            M T W TH F SAT SUN
                            0 1 2 3  4 5   6
                            
                            */
                            
                            var User_Info = [String]()
                            let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
                            
                            if(defaults!.objectForKey("ButtonTexts") != nil){
                                User_Info = defaults!.objectForKey("ButtonTexts") as! Array<String>
                            } else {
                                var count = 0
                                while count < 7 {
                                    User_Info.append("")
                                    count++
                                }
                            }
                            
                            var Switch_Info = [Bool]()
                            
                            
                            if(defaults!.objectForKey("SwitchValues") != nil){
                                Switch_Info = defaults!.objectForKey("SwitchValues") as! Array<Bool>
                            } else {
                                var count = 0
                                while count < 5 {
                                    Switch_Info.append(true)
                                    count++
                                }
                            }
                            
                            
                            var dayCounter = 0;
                            
                            
                            for day in self.Days{
                                
                                
                                
                                print(self.Days.count)
                                print("")
                                print("")
                                print("")
                                
                                print("before crash" )
                                print(Switch_Info);
                                print(dayCounter);
                                
                                var firstLunch = Switch_Info[dayCounter]
                                
                                for (date,block) in day.time_to_block{
                                    
                                    
                                    //NEW STUFF
                                    var mutable_date = date; //we store it as a date that can be changed because for 2nd lunch we will change the time
                                    //NEW STUFF
                                    
                                    
                                    
                                    
                                    
                                    var message = block;
                                    var block_copy = block;
                                    
                                    
                                    print("Block " + block + " ", terminator: "")
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    if(block_copy.characters.count == 2) {
                                        
                                        if(firstLunch && block_copy.hasSuffix("1")){
                                            
                                            
                                            message = "Lunch"
                                            
                                            
                                            
                                        }
                                        else if(!firstLunch && block_copy.hasSuffix("2")){
                                            
                                            message = "Lunch"
                                            
                                            
                                            
                                            //NEW STUFF
                                            //we just fire at a different date than the one parse orginally said, we fire at the the second lunch start time
                                            var time_of_secondLunch = self.Second_Lunch_Start[dayCounter];
                                            mutable_date = Monday.timeToNSDate(time_of_secondLunch);
                                            //NEW STUFF
                                            
                                        }
                                        else{
                                            
                                            //gets first character of block
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
                                    if(message == "Lunch"){
                                        var RegularDate = mutable_date;
                                        let localNotification:UILocalNotification = UILocalNotification()
                                        localNotification.alertAction = "Glancer"
                                        localNotification.alertBody = message;
                                        day.messages_forBlock[block] = message;
                                        
                                        RegularDate = RegularDate.dateByAddingTimeInterval(60 * 60 * 24 * index);
                                        let DateScheduled = day.NSDateToString(RegularDate)
                                        print(day.name + " Date Scheduled : " + DateScheduled + " " + message)
                                        localNotification.fireDate = RegularDate
                                        localNotification.repeatInterval = NSCalendarUnit.WeekOfYear
                                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                                        
                                        
                                    }else{
                                        
                                        var Earlydate = mutable_date.dateByAddingTimeInterval(-60*5)
                                        
                                        
                                        
                                        let localNotification:UILocalNotification = UILocalNotification()
                                        localNotification.alertAction = "Glancer"
                                        localNotification.alertBody = "5 minutes to get to " + message;
                                        
                                        
                                        
                                        day.messages_forBlock[block] = message;
                                        
                                        
                                        Earlydate = Earlydate.dateByAddingTimeInterval(60 * 60 * 24 * index)
                                        
                                        
                                        let DateScheduled = day.NSDateToString(Earlydate)
                                        print(day.name + " Date Scheduled : " + DateScheduled + " " + message)
                                        localNotification.fireDate = Earlydate
                                        localNotification.repeatInterval = NSCalendarUnit.WeekOfYear
                                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                dayCounter++;
                                index++;
                                
                            }
                            
                            Success = true;

                            
                        }
                        else{
                            
                            print("vacation");
                            
                        }
                        
  
                    


                    }else{
                        
                        print("Boool is not made - Failed!")
                        
                    }
                    
                    
                } else {
                    print("Error - Failed!")
                }
        }
        return Success
    }

    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        Timer.invalidate()
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        let x = update();
        
        
        print("Fetching")
        
        
        if(x){
            
            completionHandler(.NewData)
        }
        else{
            completionHandler(.Failed)
        }
        
        
        print("Fetching Done")
        
        
    }
    
    
}



