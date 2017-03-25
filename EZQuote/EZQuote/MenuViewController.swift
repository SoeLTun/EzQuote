//
//  MenuViewController.swift
//  EZQuote
//
//  Created by Soe Tun on 8/1/15.
//  Copyright (c) 2015 CMPE180-95. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

   
    
    var data: String!
    
    
    
    @IBAction func byImage(sender: AnyObject) {
        moveToNextpage(data)
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //  l1.text = data
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToNextpage (userID: String)
    {
       
        let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("Upload") as! UploadViewController
       
        menuVC2.userID = userID
       
        self.navigationController?.pushViewController(menuVC2, animated: true)
     

        
    }

    
}
