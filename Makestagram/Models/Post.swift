//
//  Post.swift
//  Makestagram
//
//  Created by Stanford on 2016-07-13.
//  Copyright © 2016 Make School. All rights reserved.
//


import Foundation
import Parse

// 1 custom Parse class needs to inherit from PFObject and PFSubclassing protocol

class Post: PFObject, PFSubclassing {
    
    var photoUploadTask: UIBackgroundTaskIdentifier? // requests extra time for photo uploads
    
    var image: UIImage?
    
    //2 define each property that you want to access on parse, allows us to change the code that accesses properties through strings
    @NSManaged var imageFile: PFFile? //@NSManaged tells swift that it will not initialize the properties in the initializer, Parse will do it
    @NSManaged var user: PFUser?
    
    //MARK: PFSubclassing protocol
    
    //3 parseClassName static function - can create a connection between Parse class and the swift class
    static func parseClassName() -> String {
        return "Post"
    }
    
    //4 init and initialize are boilerplate code - copy these two into any custom Parse class that you're creating.
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    //when uploadPost is called, grab photo turn it into PFFile called imageFile. assign imageFile to self.imageFile. Then upload it to Parse
    func uploadPost() {
        if let image = image {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return} //UIImage into an NSData instance because the PFFile class needs an NSData argument for its initializer. guard is used to unwrap optionals
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return} //creates and saves PFFile
            
            user = PFUser.currentUser() // any uploaded posts should be associated with the current user
            self.imageFile = imageFile
            
            
            // 1 When background task is created, Unique ID is generated and returned and stored in photoUploadTask. API requires expirationHandler in form of a closure. Closure runs when permitted time is expired (so it can cancel the task)
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!) //this was called to prevent the app from being terminated
            }
            
            // 2 After we created the background task, save the post and imageFile by calling saveInBackgroundWithBlock
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in //callback is not needed, that's why nil is there to take it's place
                
                // informs iOS that our background task is completed, called as soon as upload is finished. (API makes us reponsible for calling this)
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
    }
}
}