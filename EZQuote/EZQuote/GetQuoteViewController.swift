//
//  GetQuoteViewController.swift
//  EZQuote
//
//  Created by Soe Tun on 8/1/15.
//  Copyright (c) 2015 CMPE180-95. All rights reserved.
//

import UIKit

class GetQuoteViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var userID: String!
    
    @IBOutlet weak var selectImage: UIImageView!
    
  
    @IBAction func addImage() {
        
        
        let selectImage = UIImagePickerController()
        selectImage.editing = false
        selectImage.delegate = self
        
        let actionSheet = UIAlertController(title: "Select Method", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let libraryBtn = UIAlertAction(title: "Select from photo library", style: UIAlertActionStyle.Default) { (libSelected) -> Void in
            print("Libary Selected")
            selectImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(selectImage, animated: true, completion: nil)
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

    
    
    @IBAction func requestQuickQuote(sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
