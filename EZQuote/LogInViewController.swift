//
//  LogInViewController.swift
//  EZQuote
//
//  Created by Soe Tun on 8/1/15.
//  Copyright (c) 2015 CMPE180-95. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

   
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    @IBOutlet weak var loginEmail: UITextField!
    
    
    @IBOutlet weak var loginPassword: UITextField!
    
    
    
    /*This function checks there are missing inputs and
        validates a  user's email and password
    */
    
    @IBAction func LoginBtn() {
        //check both email and password
        if loginEmail.text == "" && loginPassword.text == ""
        {
            print("Both Missing")
            let alertBox = UIAlertController(title: "Alert!", message: "Email and password is missing", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (libSelected) -> Void in }
            alertBox.addAction(dismissButton)
            self.presentViewController(alertBox, animated: true, completion: nil)
            
        }
            
        // check for email
        else if loginEmail.text == ""
        {
            print("Email Missing")
            let alertBox = UIAlertController(title: "Alert!", message: "Email  is missing", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (libSelected) -> Void in }
            alertBox.addAction(dismissButton)
            self.presentViewController(alertBox, animated: true, completion: nil)
            
        }
            
        // check for password
        else if loginPassword.text == ""
        {
            print("Passeword Missing")
            let alertBox = UIAlertController(title: "Alert!", message: "Password  is missing", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (libSelected) -> Void in }
            alertBox.addAction(dismissButton)
            self.presentViewController(alertBox, animated: true, completion: nil)
            
        }
        
        // validate email and password
        else
        {
            let username = loginEmail.text
            let password = loginPassword.text
            
            validateLogin("http://ezquote-server.herokuapp.com/login?email=\(username!)&password=\(password!)")
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wait.hidden = true
        
        // Do any additional setup after loading the view.
    }

    func moveToNextpage (userID: String)
    {
        let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("Menu") as!MenuViewController
        menuVC2.data = userID
        self.navigationController?.pushViewController(menuVC2, animated: true)
        wait.stopAnimating()
        wait.hidden = true
    }

    
func validateLogin(urlString: String)
{
    
    wait.hidden = false
    wait.startAnimating()
    
    let loginURL:NSURL = NSURL(string: urlString)!
    let task1 = NSURLSession.sharedSession().dataTaskWithURL(loginURL)
        {
            
            (data,response, error) in
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            print(loginURL)
           
            let responseNum = responseString?.integerValue
            print (responseNum!)
            
            if responseNum != 0
            {
                
                self.performSelectorOnMainThread("confirmMessage:",withObject: responseString, waitUntilDone:false)
                //self.performSelectorOnMainThread("moveToNextpage:",withObject: responseData, waitUntilDone:false)
                // dispatch_async(dispatch_get_main_queue(), {self.lblMessage.text = responseString! as String})
            }
            else
            {
                self.performSelectorOnMainThread("denyMessage:",withObject: responseString, waitUntilDone:false)
                
            }

    }
    task1.resume()
}

    func confirmMessage(userID: String)
    {
        print("Entring")
        goNext(userID)
    }
    
    func goNext(userID: String)
    {
        moveToNextpage(userID)
    }
    
    func denyMessage(UserID: String)
    {
        print("Login Deny")
        let alertbox = UIAlertController(title: "Warning!", message: "Username or password is not valid", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in}
        
        alertbox.addAction(dismissBtn)
        self.presentViewController(alertbox, animated: true, completion: nil)
        
        wait.stopAnimating()
        wait.hidden = true
        loginEmail.text = ""
        loginPassword.text = ""
    }

    
    
    
    
}
