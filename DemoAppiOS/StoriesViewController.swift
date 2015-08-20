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
    var refreshingData = false
    
    //This array stores the stories that are shown and is the data source for the UIDataTable
    var stories = [Story]()
    
    //This array stores all the stories retrieved.
    //The dictionary data structure prevents a story to be saved more than once
    //When a story is deleted is removed from the stories array and marked as deleted in this dictionary
    var storiesDic = [Int: Story]()
    
    var deleteStoryIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("handleRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
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
                            var story_url: String! = storyInfo["story_url"].string
                            var url: String! = storyInfo["url"].string
                            var object_id: Int! = storyInfo["objectID"].string!.toInt()
                            
                            var story = Story(object_id: object_id,
                                story_title: story_title,
                                title: title,
                                author: author,
                                created_at: created_at,
                                story_url:story_url,
                                url:url)
                            
                            if let newStory = self.storiesDic[object_id] {
                                //the story is already save, nothing to do
                            } else {
                                self.storiesDic[object_id]=story
                                
                                //If we are refreshing the new stories are added at the beginning of the list
                                if(self.refreshingData){
                                    self.stories.insert(story, atIndex: 0)
                                }else{
                                    self.stories.append(story)
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            if(self.refreshingData){
                                self.refreshControl?.endRefreshing()
                                self.refreshingData=false
                                
                                //The Stories with greater object_id are the most recent
                                self.stories.sort({ $0.object_id > $1.object_id })
                                self.tableView.reloadData();
                            }else{
                                self.stories.sort({ $0.object_id > $1.object_id })
                                self.tableView.reloadData();
                            }
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
               
        cell.textLabel!.text = story.safeTitle()
        cell.detailTextLabel!.text=story.author + " - " + story.elapsedTime()

        story.elapsedTime()
        
        return cell
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func handleRefresh() {
        refreshControl?.beginRefreshing()
        self.refreshingData = true
        getHNStories()
        
      refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            deleteStoryIndexPath = indexPath
            let storyToDelete = stories[indexPath.row]
            confirmDelete(storyToDelete)
        }
    }
    
    func confirmDelete(story: Story) {
        let alert = UIAlertController(title: "Delete story", message: "Are you sure you want to delete the story '\(story.safeTitle())'?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteStory)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteStory)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func handleDeleteStory(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteStoryIndexPath {
            tableView.beginUpdates()
            
            let deletedStory:Story = storiesDic[stories[indexPath.row].object_id]!
            deletedStory.deleted=true
            storiesDic.updateValue(deletedStory, forKey: deletedStory.object_id)
            
            stories.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteStoryIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteStory(alertAction: UIAlertAction!) {
        deleteStoryIndexPath = nil
    }
    
   

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showStoryWeb" {
            if let destination = segue.destinationViewController as? StoryDetailController {
                if let storyIndex = tableView.indexPathForSelectedRow()?.row {
                    println(stories[storyIndex].safeTitle())
                    println("url:" + stories[storyIndex].url)
                    destination.storyURL = stories[storyIndex].safeURL()
                }
            }
        }
    }
}
