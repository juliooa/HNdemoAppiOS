//
//  StoryDetailController.swift
//  DemoAppiOS
//
//  Created by Julio Olivares Alarcón on 8/18/15.
//  Copyright (c) 2015 Nicecorp. All rights reserved.
//

import UIKit

class StoryDetailController: UIViewController {

    @IBOutlet var webView: UIWebView!
    var storyURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadRequest(NSURLRequest(URL: NSURL(string: storyURL)!))
        println(storyURL)
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
