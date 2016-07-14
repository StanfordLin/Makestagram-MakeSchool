//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Stanford on 2016-07-12.
//  Copyright © 2016 Make School. All rights reserved.
//

import Parse
import UIKit

//provide function signature with a name. This says that function PhotoTakingHelperCallback has 1 parameter and returns void.It means that any function that wants to be a callback needs to have exactly this signature
typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    //View controller on which AlertViewController and UIImagePickerController are presented
    
    //PhotoTakingHelper needs a UIViewController on which it can present other view controllers, it's a weak reference because the PhotoTakingHelper does not own the referenced view controller.
    weak var viewController: UIViewController!
    
    //we store the callback function and provide a property to store a UIImagePickerController
    var callback: PhotoTakingHelperCallback
    
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        //Allow user to choose between camera and photo library
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        

        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        //Only show camera if the device has a REAR camera
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }

        alertController.addAction(cameraAction)
    }
        
    //        reference to call presentViewController. Now the popup will be displayed on whichever view controller is stored  
    viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        
        imagePickerController = UIImagePickerController() //creates UIImagePicker object
        imagePickerController!.sourceType = sourceType //takes the sourceType from the camera or photo library and passes it off to imagePickerController
        imagePickerController!.delegate = self

        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil) // once imagePickerController is initialized and configured, we present it!
        

    }
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //hide image picker controller, then we call a callback and hand it over to ?!@?!@ After this line runs the TimelineViewController will have received the image through its callback closure.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [NSObject : AnyObject]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image)
    }
    //hide the image picker controller by calling dissmissViewControllerAnimated on viewController. Before it would automatically hide it, however we're using the delegate, so it's our responsiblity to do that
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
