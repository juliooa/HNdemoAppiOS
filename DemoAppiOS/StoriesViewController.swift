//
//  StoriesViewController.swift
//  DemoAppiOS
//
//  Created by Julio Olivares Alarcón on 8/18/15.
//  Copyright (c) 2015 Nicecorp. All rights reserved.
//

import UIKit
import Alamofire

class StoriesViewController: UITableViewController {

    var populatingStories = false
    var stories = [Story]()
    var deleteStoryIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getHNStories();

    }
    
    func getHNStories() {
        if populatingStories {
            return
        }
        
        populatingStories = true
        
        Alamofire.request(HNRestClient.Router.GetStories()).validate().responseJSON() {
            (_, _, json, error) in
            
            if error == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    var jsonObj = JSON(json!)
                    
                    if let storiesInfos = jsonObj ["hits"].array {
                        
                        for storyInfo in storiesInfos {
                            
                            var story_title: String! = storyInfo["story_title"].string
                            
                            var title: String! = storyInfo["title"].string
                            
                            var author: String! = storyInfo["author"].string
                            var created_at: String! = storyInfo["created_at"].string
                            var object_id: Int! = storyInfo["objectID"].string!.toInt()
                            
                            var story = Story(object_id: object_id,
                                story_title: story_title,
                                title: title,
                                author: author, created_at: created_at)
                            
                            self.stories.append(story)
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData();
                            return
                        }
                    }
                }
            }
            
            self.populatingStories = false
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let story: Story = self.stories[indexPath.row]
        
        //todo chequear si title tien algo o no
        cell.textLabel!.text = story.safe_title()
        cell.detailTextLabel!.text=story.author + " - " + story.created_at

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            deleteStoryIndexPath = indexPath
            let storyToDelete = stories[indexPath.row]
            confirmDelete(storyToDelete)
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func confirmDelete(story: Story) {
        let alert = UIAlertController(title: "Delete story", message: "Are you sure you want to delete the story '\(story.safe_title())'?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteStoryIndexPath {
            tableView.beginUpdates()
            
            stories.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteStoryIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deleteStoryIndexPath = nil
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
