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
    let url:String=""
    let author:String
    let story_title:String
    let story_url:String=""
    let created_at:String
    
    init(object_id: Int, story_title:String?, title:String?,author:String,created_at:String) {

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
        
        self.author = author as String
        self.created_at=created_at as String
    }
    

    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! Story).object_id == self.object_id
    }
    
    override var hash: Int {
        return (self as Story).object_id
    }
    
    func safe_title()-> String {
        if self.title.isEmpty {
            return self.story_title
        }else{
            return self.title
        }
    }
    
}
