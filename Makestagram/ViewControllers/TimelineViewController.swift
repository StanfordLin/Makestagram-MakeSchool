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
    
    @IBOutlet weak var tableView: UITableView!
    
    //query that returns post
    let postsQuery = Post.query()
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var posts: [Post] = []
    
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
    
    override func viewDidAppear(animated: Bool) {
        
//        
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
//        
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
//        
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
//        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        
//        
        query.includeKey("user")
        
//      
        query.orderByDescending("createdAt")
        
//        
        query.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            
//            
            self.posts = result as? [Post] ?? []
//            
            self.tableView.reloadData()
        
        
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

    extension TimelineViewController: UITableViewDataSource {
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // 1
            return posts.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // 2
            let cell = tableView.dequeueReusableCellWithIdentifier("PostCell")!
            
            cell.textLabel!.text = "Post"
            
            return cell
        }
}


