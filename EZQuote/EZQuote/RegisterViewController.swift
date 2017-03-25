//
//  RegisterViewController.swift
//  EZQuote
//
//  Created by Soe Tun on 8/1/15.
//  Copyright (c) 2015 CMPE180-95. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var cpass: UILabel!
    @IBOutlet weak var pass: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var successMessage: UILabel!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    @IBOutlet weak var registerConfirmPassword: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    
    var passData:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        wait.hidden = true
        successMessage.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerSignUpBtn(sender: AnyObject) {
        // check all three fields
    if registerEmail.text == "" && registerPassword.text == "" && registerConfirmPassword.text == ""
    {
        print("all three are missing")
        let alertbox = UIAlertController(title: "Alert!", message: "Input fields are empty", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in
        }
        alertbox.addAction(dismissBtn)
        self.presentViewController(alertbox, animated: true, completion: nil)
    }
        // check email
        else if registerEmail.text == ""
    {
        print("Email is misssing")
        let alertbox = UIAlertController(title: "Alert!", message: "Email is missing", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in
        }
        alertbox.addAction(dismissBtn)
        self.presentViewController(alertbox, animated: true, completion: nil)
    }
        
        // check password
        else if  registerPassword.text == ""
    {
        print("Password is missing")
        let alertbox = UIAlertController(title: "Alert!", message: "Password is missing", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in
        }
        alertbox.addAction(dismissBtn)
        self.presentViewController(alertbox, animated: true, completion: nil)
        }
        
        // check confirm password
        else if registerConfirmPassword == ""
    {
        
        print("Confirm is missing")
        let alertbox = UIAlertController(title: "Alert!", message: "Confirm password is missing", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in
        }
        alertbox.addAction(dismissBtn)
        self.presentViewController(alertbox, animated: true, completion: nil)
        }
        
        
        else{
        
            let email = registerEmail.text
            let password = registerPassword.text
            let confirmpassword = registerConfirmPassword.text
        
        
        
        
        
            // show error message
            if !isValidateEmail(email!)
            {
                
                print("Invalid")
                let alertbox = UIAlertController(title: "Warning!", message: "Email address is not valid", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in}
                
                alertbox.addAction(dismissBtn)
                self.presentViewController(alertbox, animated: true, completion: nil)

            }
        
            // check both passwords are equal or not
            else if password != confirmpassword
            {
                print("Password and confirm password are not equal")
                let alertbox = UIAlertController(title: "Warning!", message: "Password and confirm password do not match", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in}
                
                alertbox.addAction(dismissBtn)
                self.presentViewController(alertbox, animated: true, completion: nil)
            }
            
            //  register begin
            else
            {
                
                validateRegisteration("http://ezquote-server.herokuapp.com/newUser?email=\(email!)&password=\(password!)")
                
            }
        
        }
    }
    
    
    // Check valid email or not
    func isValidateEmail(email:String) -> Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
        
        
    }
    
    func validateRegisteration(urlString: String)
    {
        wait.hidden = false
        wait.startAnimating()
        
        let regURL:NSURL = NSURL(string: urlString)!
        let task1 = NSURLSession.sharedSession().dataTaskWithURL(regURL)
            {
                
                ( data, response, error) in
               
                
                let responseData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
               

                print("****** response data = \(responseData)")
                print(regURL)
                let responseNum = responseData?.integerValue
                self.passData = responseNum
                print (responseNum!)
               
                if responseNum != 0
                {
                    
                    self.performSelectorOnMainThread("confirmMessage:",withObject: responseData, waitUntilDone:false)
                    //self.performSelectorOnMainThread("moveToNextpage:",withObject: responseData, waitUntilDone:false)
                    // dispatch_async(dispatch_get_main_queue(), {self.lblMessage.text = responseString! as String})
                }
                else
                {
                    self.performSelectorOnMainThread("denyMessage:",withObject: responseData, waitUntilDone:false)
                    
                }
        }
        task1.resume()
    }
    
    
    func moveToNextpage (userID: Int)
    {
        let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("LogIn") as!LogInViewController
        self.navigationController?.pushViewController(menuVC2, animated: true)
        wait.stopAnimating()
    }

    func confirmMessage(userID: Int)
    {
        print("Registering")
         successMessage.hidden = false
         wait.stopAnimating()
         wait.hidden = true
         registerEmail.hidden = true
         registerPassword.hidden = true
         registerConfirmPassword.hidden = true
         email.hidden = true
         pass.hidden = true
        cpass.hidden = true
        btn.hidden = true
        
    
       var timer = NSTimer()
       timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "goNext", userInfo:nil, repeats: false)
       NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
       
    }
    func goNext()
    {
        moveToNextpage(passData)
         successMessage.hidden = true
    }
    
    func denyMessage(UserID: Int)
    {
        print("Register Deny")
        let alertbox = UIAlertController(title: "Failed!", message: "The account already exists", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in}
        alertbox.addAction(dismissBtn)
        self.presentViewController(alertbox, animated: true, completion: nil)
        
        wait.stopAnimating()
        wait.hidden = true
        registerEmail.textColor = UIColor.redColor()
        registerPassword.text = ""
        registerConfirmPassword.text = ""
        
    }
    
}
