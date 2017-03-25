//
//  ForgetPassword.swift
//  EZQuote
//
//  Created by Soe Tun on 11/21/15.
//  Copyright © 2015 CMPE180-95. All rights reserved.
//

import UIKit

class ForgetPassword: UIViewController {

    @IBOutlet weak var accountEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func submitBtn(sender: AnyObject) {
        
        if accountEmail.text == ""
        {
            print("Email address is missing")
            let alertbox = UIAlertController(title: "Warning!", message: "Input field is empty.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in
            }
            alertbox.addAction(dismissBtn)
            self.presentViewController(alertbox, animated: true, completion: nil)
        }
        else
        {
            let email = accountEmail.text
            if !isValidateEmail(email!)
            {
                
                print("Invalid")
                let alertbox = UIAlertController(title: "Warning!", message: "Email address is not valid.", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){(libSelected) -> Void in}
                
                alertbox.addAction(dismissBtn)
                self.presentViewController(alertbox, animated: true, completion: nil)
                
            }

        }
    }
    
    // Check valid email or not
    func isValidateEmail(email:String) -> Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
        
        
    }
}
