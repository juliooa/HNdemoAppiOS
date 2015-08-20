//
//  Story.swift
//  DemoAppiOS
//
//  Created by Julio Olivares Alarcón on 8/18/15.
//  Copyright (c) 2015 Nicecorp. All rights reserved.
//

import UIKit

class Story: NSObject {
    
    let object_id: Int
    let title: String
    let url:String
    let author:String
    let story_title:String
    let story_url:String
    let created_at:String
    
    var deleted:Bool=false
    
    init(object_id: Int, story_title:String?, title:String?,author:String,created_at:String,story_url:String?,url:String?) {

        self.object_id = object_id
        
        if story_title != nil{
            self.story_title=story_title!
        }else{
            self.story_title=""
        }
        if title != nil{
            self.title=title!
        }else{
            self.title=""
        }
        if story_url != nil{
            self.story_url=story_url!
        }else{
            self.story_url=""
        }
        if url != nil{
            self.url=url!
        }else{
            self.url=""
        }
        
        self.author = author as String
        self.created_at=created_at as String
    }
    

    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! Story).object_id == self.object_id
    }
    
    override var hash: Int {
        return (self as Story).object_id
    }
    
    func safeURL()-> String {
        if self.url.isEmpty {
            return self.story_url
        }else{
            return self.url
        }
    }
    
    func safeTitle()-> String {
        if self.title.isEmpty {
            return self.story_title
        }else{
            return self.title
        }
    }
    
    func elapsedTime() -> String{
        
        let dateFromServerFormatter = NSDateFormatter()
        dateFromServerFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFromServerFormatter.timeZone = NSTimeZone.localTimeZone()
        let createdAtDate = dateFromServerFormatter.dateFromString(self.created_at) as NSDate!

        var elapsedTime = NSDate().timeIntervalSinceDate(createdAtDate)
        var mesure :String = "s"
        
        if elapsedTime>60{
            elapsedTime=elapsedTime/60
            mesure="m"
        }
        if elapsedTime>60{
            elapsedTime=elapsedTime/60
            mesure="h"
        }
        
        return String(format:"%.0f", round(elapsedTime)) + mesure
    }
    
}
