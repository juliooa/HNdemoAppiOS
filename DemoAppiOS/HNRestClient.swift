//
//  HNRestClient.swift
//  DemoAppiOS
//
//  Created by Julio Olivares Alarcón on 8/18/15.
//  Copyright (c) 2015 Nicecorp. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct HNRestClient {
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://hn.algolia.com/api/v1"
        
        case GetStories()
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .GetStories():
                    let params = ["query": "ios"]
                    return("/search_by_date",params)
                }
            }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    
}