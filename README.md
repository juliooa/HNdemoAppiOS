
Reigndesign iOS sample app
===================================

This sample app gets the last stories from Hacker News(https://news.ycombinator.com/)
using their API. For this app the call http://hn.algolia.com/api/v1/search_by_date?query=iOS
is used.


In the retrieved JSON objects, I notice the only unique identifier is the field "objectID",
so I'm using this field as main id for the stories.

The UITableView has the feature of pull-to-refresh and swipe-to-delete items.
In this project the following libraries are used:

* Alamofire to manage the network requests (https://github.com/Alamofire/Alamofire)
* SwiftyJSON to handle the JSON responses (https://github.com/SwiftyJSON/SwiftyJSON)

This app was written in Swift 1.2

Requirements
--------------
- iOS 8.0+ / Mac OS X 10.9+
- Xcode 6.4
