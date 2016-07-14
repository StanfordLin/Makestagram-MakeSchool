//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Stanford on 2016-07-12.
//  Copyright © 2016 Make School. All rights reserved.
//
import Parse
import UIKit



class TimelineViewController: UIViewController {
    
    var photoTakingHelper: PhotoTakingHelper?
    
    //store instance of PhotoTakingHelper class as a property of TimelineViewController

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
    func takePhoto() {
        //instantiate photo taking class, provide callback for when the photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let post = Post()
            post.image = image
            post.uploadPost()
            
        }
    }
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
}



