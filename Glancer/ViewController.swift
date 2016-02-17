//
//  ViewController.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    
    //Since you will do this programtically the following can go.
    @IBOutlet weak var Blue: UIView!
    @IBOutlet weak var M: UISwitch!
    @IBOutlet weak var T: UISwitch!
    @IBOutlet weak var W: UISwitch!
    @IBOutlet weak var Th: UISwitch!
    @IBOutlet weak var F: UISwitch!
  
    
    @IBOutlet weak var Save: UIButton! //this is a save button
    
    
    @IBOutlet weak var blockViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var blockViewBottomConstraint: NSLayoutConstraint!
    

    @IBOutlet var Gblock: UITextField!
    @IBOutlet var Fblock: UITextField!
    @IBOutlet var Eblock: UITextField!
    @IBOutlet var Dblock: UITextField!
    @IBOutlet var Ablock: UITextField!
    @IBOutlet var Bblock: UITextField!
    @IBOutlet var Cblock: UITextField!
    //END
    
    //try and keep these and work the UI with them
    var ArrayOfField = [UITextField]()
    var ArrayOfSwitch = [UISwitch]()
    var ArrayOfBool = [Bool]()
    var ArrayOfText = [String]()
    //END
    
    

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  
    
    var timer = NSTimer();
    
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")
        //Change here
        
        
        //Make sure to add all the Ui element's values (string) to "ArrayOfText"
        ArrayOfText.append(Ablock.text!)
        ArrayOfText.append(Bblock.text!)
        ArrayOfText.append(Cblock.text!)
        ArrayOfText.append(Dblock.text!)
        ArrayOfText.append(Eblock.text!)
        ArrayOfText.append(Fblock.text!)
        ArrayOfText.append(Gblock.text!)
        
        //this actauly holds the UI elements, you will make these prgramtically but add the "UITextField" to "ArrayOfField"
        ArrayOfField.append(Ablock)
        ArrayOfField.append(Bblock)
        ArrayOfField.append(Cblock)
        ArrayOfField.append(Dblock)
        ArrayOfField.append(Eblock)
        ArrayOfField.append(Fblock)
        ArrayOfField.append(Gblock)
        
        //Make sure to add all the Ui element's values (bool) to "ArrayOfBool"
        ArrayOfBool.append(M.on)
        ArrayOfBool.append(T.on)
        ArrayOfBool.append(W.on)
        ArrayOfBool.append(Th.on)
        ArrayOfBool.append(F.on)
        
        //this holds the UI elemnts, the switches for first lunch, you will make these prgramtically but add "UISwitch" to "ArrayOfField"

        ArrayOfSwitch.append(M)
        ArrayOfSwitch.append(T)
        ArrayOfSwitch.append(W)
        ArrayOfSwitch.append(Th)
        ArrayOfSwitch.append(F)
        
        
        //you probabbly can get rid of this
        
        self.Gblock.delegate = self;
        self.Fblock.delegate = self;
        self.Eblock.delegate = self;
        self.Dblock.delegate = self;
        self.Ablock.delegate = self;
        self.Bblock.delegate = self;
        self.Cblock.delegate = self;
        //gettring Rid Ends
        
        //Change Ends
  
        

        if(defaults!.objectForKey("ButtonTexts") == nil){
            defaults!.setObject(ArrayOfText, forKey: "ButtonTexts")
        }
        else {
            let UserArray: [String] = defaults!.objectForKey("ButtonTexts") as! Array<String>
            
            for index in 0...UserArray.count-1{
                ArrayOfField[index].text = UserArray[index]
            }
        }
        
        if(defaults!.objectForKey("SwitchValues") == nil){
            defaults!.setObject(ArrayOfBool, forKey: "SwitchValues")
        }
        else {
            let UserSwitch: [Bool] = defaults!.objectForKey("SwitchValues") as! Array<Bool>
            
            for index in 0...UserSwitch.count-1{
                ArrayOfSwitch[index].on = UserSwitch[index]
            }
        }
        
        
        Save.addTarget(self, action: "buttonTapped", forControlEvents: .TouchUpInside)
        
      
        appDelegate.update()
        
        
        }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    //STUFF FOR MOVING VIEWS WHEN TEXTFIELD ACTIVATED
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(Dblock) {
            self.setViewMovedUp(true)
        } else if textField.isEqual(Eblock) {
            self.setViewMovedUp(true)
        } else if textField.isEqual(Fblock) {
            self.setViewMovedUp(true)
        } else if textField.isEqual(Gblock) {
            self.setViewMovedUp(true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.isEqual(Dblock) {
            self.setViewMovedUp(false)
        } else if textField.isEqual(Eblock) {
            self.setViewMovedUp(false)
        } else if textField.isEqual(Fblock) {
            self.setViewMovedUp(false)
        } else if textField.isEqual(Gblock) {
            self.setViewMovedUp(false)
        }
    }
    
    func setViewMovedUp(movedUp: Bool) {
    
        if (movedUp) {
            self.blockViewTopConstraint.constant = -216
            self.blockViewBottomConstraint.constant = 216
        } else {
            self.blockViewTopConstraint.constant = 0
            self.blockViewBottomConstraint.constant = 0
        }
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    //END - Kane
        


    
    
    
    func buttonTapped(){ //this is what happens if save button is pressed!

        
        print("saved press");
        
        let defaults = NSUserDefaults(suiteName:"group.vishnu.squad.widget")

        
        ArrayOfText.removeAll()
        ArrayOfBool.removeAll()
        
        
        //CHANGE starts here
        
        //probably will have to change this. Make sure to add the values (string) to  "ArrayOfText"

        ArrayOfText.append(Ablock.text!)
        ArrayOfText.append(Bblock.text!)
        ArrayOfText.append(Cblock.text!)
        ArrayOfText.append(Dblock.text!)
        ArrayOfText.append(Eblock.text!)
        ArrayOfText.append(Fblock.text!)
        ArrayOfText.append(Gblock.text!)
        
        //probably will have to change this. Make sure to add the values (bool) to "ArrayOfBool"
        ArrayOfBool.append(M.on)
        ArrayOfBool.append(T.on)
        ArrayOfBool.append(W.on)
        ArrayOfBool.append(Th.on)
        ArrayOfBool.append(F.on)
        
        
        //Change ends here
        
        
        
        defaults!.setObject(ArrayOfText, forKey: "ButtonTexts")
        defaults!.setObject(ArrayOfBool, forKey: "SwitchValues")
        
        
        appDelegate.update()

        
        
        
        print("_____________________________________________________________________")
        print("Scheduled Notifications")

        
        let alert = UIAlertController(title: "Saved!", message: "Your data has been saved.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    
    
}

