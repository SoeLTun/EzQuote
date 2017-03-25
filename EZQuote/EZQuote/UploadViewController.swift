//
//  UploadViewController.swift
//  EZQuote
//
//  Created by Soe Tun on 11/22/15.
//  Copyright © 2015 CMPE180-95. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var userID: String!
    var frameID: String!
    
    @IBOutlet weak var frameView: UIImageView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wait.hidden = true
        frameID = "1"
       self.selectImage.image = self.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func imageSelect(sender: AnyObject) {
    
        let selectImage = UIImagePickerController()
        selectImage.editing = false
        selectImage.delegate = self;
        
        let actionSheet = UIAlertController(title: "Select Method", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let libraryBtn = UIAlertAction(title: "Select from photo library", style: UIAlertActionStyle.Default) { (libSelected) -> Void in
            print("Libary Selected")
            
           // selectImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //self.presentViewController(selectImage, animated: true, completion: nil)
            
            let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("selectPhoto") as! photoSelectViewController
            self.navigationController?.pushViewController(menuVC2, animated: true)
            
        }
        
        let cameraBtn = UIAlertAction (title: "Take Photo", style: UIAlertActionStyle.Default)
            {(libSelected) -> Void in
                print("Camera Selected")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                {
                    selectImage.sourceType = UIImagePickerControllerSourceType.Camera
                    self.presentViewController(selectImage, animated:true, completion: nil)
                }
                else
                {
                    print("Camera Selected")
                }
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (cancelSelected) -> Void in
            print("Cancel Selected")
        }
        actionSheet.addAction(libraryBtn)
        actionSheet.addAction(cameraBtn)
        actionSheet.addAction(cancelBtn)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion:nil)
        self.selectImage.image = image
    }
    
    
    
    @IBAction func uploadBtn(sender: AnyObject) {
        if !s1.on && !s2.on && !s3.on && !s4.on && !s5.on
        {
            frameID = "1"
            s1.on = true
            frameView.image = UIImage(named:"1overlay")
        }
        myImageUploadRequest()  
    }
    
    
    func myImageUploadRequest()
    {
        wait.hidden = false
        wait.startAnimating();
        
        //let myUrl = NSURL(string: "http://www.swiftdeveloperblog.com/http-post-example-script/");
        
        let myUrl = NSURL(string: "http://ezquote-server.herokuapp.com/userImageUpload");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            
            "userId" : userID!,
            "selectedFrame" :frameID!
        ]
        print("SElect Frame --> \(frameID)")
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(selectImage.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
       
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            print("1")
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print("****** response data = \(responseString!)")
            
            var err: NSError?
            var json = (try!  NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
            
            let meg = json["Message"] as! String
            let imgID = json["Id"] as! String
            
            print(meg)
            print(imgID)
            
            
        
            if meg == "ImageProcessed"
            {
                
                self.performSelectorOnMainThread("nextPage:",withObject: imgID, waitUntilDone:false)

            }
            
            else
            {
                let alertBox = UIAlertController(title: "Warning!", message: "Could not upload Image.", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel){ (libSelected) -> Void in }
                alertBox.addAction(dismissButton)

            }
            
            
            
            
        }
        
        task.resume()
        
        
    }
    
    func nextPage(imgID: String){
        wait.stopAnimating();
        wait.hidden = true
        let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("DisplayImage") as!ImageDownload
        menuVC2.imgID = imgID
        menuVC2.userID = self.userID
        self.navigationController?.pushViewController(menuVC2, animated: true)
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
                print(key)
            }
            
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        print(filePathKey)
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func goNext(userID: String, imgID: String)
    {
        moveToNextpage (userID, imgID: imgID)
    }

    
    func moveToNextpage(userID: String, imgID: String)
    {
        let menuVC2 = self.storyboard!.instantiateViewControllerWithIdentifier("Menu") as!MenuViewController
        menuVC2.data = userID
        self.navigationController?.pushViewController(menuVC2, animated: true)
        
    }

    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    @IBOutlet weak var s1: UISwitch!
    
    @IBOutlet weak var s2: UISwitch!
    
    @IBOutlet weak var s3: UISwitch!
    
    @IBOutlet weak var s4: UISwitch!
    
    @IBOutlet weak var s5: UISwitch!
    
    
    @IBAction func s1Press(sender: AnyObject) {
        
        if s1.on
        {
            frameID = "1"
            s2.on = false
            s3.on = false
            s4.on = false
            s5.on = false
            frameView.image = UIImage(named:"1overlay")
            print(frameID)
        }
        
    }
    
    
    @IBAction func s2Press(sender: AnyObject) {
        if s2.on
        {
            frameID = "2"
            s1.on = false
            s3.on = false
            s4.on = false
            s5.on = false
            frameView.image = UIImage(named:"25")
            print(frameID)
        }

    }
    
    @IBAction func s3Press(sender: AnyObject) {
        if s3.on
        {
            frameID = "3"
            s1.on = false
            s2.on = false
            s4.on = false
            s5.on = false
            frameView.image = UIImage(named:"26")
            print(frameID)
        }

    }
    
    @IBAction func s4Press(sender: AnyObject) {
        if s4.on
        {
            frameID = "4"
            s1.on = false
            s3.on = false
            s2.on = false
            s5.on = false
            frameView.image = UIImage(named:"27")
            print(frameID)
        }

    }
    
    @IBAction func s5Press(sender: AnyObject) {
        if s5.on
        {
            frameID = "5"
            s1.on = false
            s3.on = false
            s4.on = false
            s2.on = false
            frameView.image = UIImage(named:"28")
            print(frameID)
        }

    }
    

    
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
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
