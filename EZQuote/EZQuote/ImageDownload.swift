//
//  ImageDownload.swift
//  EZQuote
//
//  Created by Soe Tun on 11/21/15.
//  Copyright © 2015 CMPE180-95. All rights reserved.
//

import UIKit

class ImageDownload: UIViewController {

    var imgID: String!
    var userID: String!
    var flag: Int!
    var count: Int! = 0
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var wait: UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("The image ID:\t\(imgID)")
        
        
        looper()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load_image1()
    {
       let urlString:String! = "http://ezquote-server.herokuapp.com/returnQuote?id=166"
        let imgURL1:NSURL = NSURL(string: urlString)!
        print(imgURL1)
        let task1 = NSURLSession.sharedSession().dataTaskWithURL(imgURL1)
            {
                
                (data, response, error) in
                
                // Parse Response
                print("******  response = \(response)")
                let httpResponse = response as! NSHTTPURLResponse
                let price = httpResponse.allHeaderFields["price"] as! String
                print("Price-->\(price)")
                var d:Int = 0
                
                data!.getBytes(&d, length: sizeof(Int))
                print("photoResponse--->\(d)")
            if  d == 48
             {
                  print("there is no image")
                  self.flag = 0
                  if self.count == 2
                  {
                    
                    self.performSelectorOnMainThread("showAlertBox:", withObject: "Alert Called", waitUntilDone:false)
                  }
                  else{
                  self.performSelectorOnMainThread("shortLooper:", withObject: price, waitUntilDone:false)
                }
              }
            else
            {
                    self.flag = 1
                   print("the image is downloaded" )
             }
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("\n\n******  data = \(dataString)")
                
                
                
                
                    
                    self.performSelectorOnMainThread("addText:", withObject: price, waitUntilDone: false)
                    self.performSelectorOnMainThread("addImage:", withObject: data, waitUntilDone: false)
                
                
                
                
                
                //dispatch_async(dispatch_get_main_queue(), {self.image.image = UIImage(data:data!)})
        }
        task1.resume()
        
       
    }
    
    @IBAction func goBackMenu(sender: AnyObject) {
        let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("Menu") as!MenuViewController
        menuVC2.data = userID
        self.navigationController?.pushViewController(menuVC2, animated: true)
    }
    
    
    func addText(txt:String)
    {
        if flag == 0 {
            print("flag zero is wokring IN Price")
            
        }
        else{
            self.quote.text = txt

        }
       
    }
    
    func addImage(data: NSData)
    {
            if flag == 0
            {
               print("flag zero is wokring IN Image")
        }
        else
            {
            self.wait.stopAnimating()
            self.wait.hidden = true
            self.flag = 1
            self.image.image = UIImage(data:data)
        
        }
        
    
    }

    func looper()
    {
        wait.hidden = false
        wait.startAnimating()
         print("*******------- 15s Looper Called----------******")
            var timer = NSTimer()
            timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "load_image1", userInfo:nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

    }

    func shortLooper(txt:String)
    {
       // wait.hidden = false
       // wait.startAnimating()
        print("*******------- 5s Looper Called----------******")
        count = count + 1
        print(count)
        var timer1 = NSTimer()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "load_image1", userInfo:nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer1, forMode: NSRunLoopCommonModes)
        
    }

    func showAlertBox ( txt: String)
    {
        print(txt)
        let alertbox = UIAlertController(title: "Warning!", message: "Failed to download the overlay image.", preferredStyle: UIAlertControllerStyle.Alert)
        let dismissBtn = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default){(libSelected) -> Void in
            self.wait.hidden = true
            self.wait.stopAnimating()
        }
        let retryBtn = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {(libSelected) -> Void in
            print("Retry Selected")
            self.looper()
        }
        alertbox.addAction(dismissBtn)
        alertbox.addAction(retryBtn )
        self.presentViewController(alertbox, animated: true, completion: nil)
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
