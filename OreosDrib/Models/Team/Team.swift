//
//  Team.swift
//  OreosDrib
//
//  Created by P36348 on 25/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON

class Team {
    
    var id: String = ""
    
    var name: String = ""
    
    var userName: String = ""
    
    var html: String = ""
    
    var avator: String = ""
    
    var bio: String = ""
    
    var location: String = ""
    
    var links: JSON = [:]
    
    init(json: JSON) {
        id = json["id"].stringValue
        
        name = json["name"].stringValue
        
        userName = json["userName"].stringValue
        
        html = json["html_url"].stringValue
        
        avator = json["avator_url"].stringValue
        
        bio = json["bio"].stringValue
        
        location = json["location"].stringValue
        
        links = json["links"]
    }
}

/**
 "team" : {
 "id" : 39,
 "name" : "Dribbble",
 "username" : "dribbble",
 "html_url" : "https://dribbble.com/dribbble",
 "avatar_url" : "https://d13yacurqjgara.cloudfront.net/users/39/avatars/normal/apple-flat-precomposed.png?1388527574",
 "bio" : "Show and tell for designers. This is Dribbble on Dribbble.",
 "location" : "Salem, MA",
 "links" : {
 "web" : "http://dribbble.com",
 "twitter" : "https://twitter.com/dribbble"
 }
 */
