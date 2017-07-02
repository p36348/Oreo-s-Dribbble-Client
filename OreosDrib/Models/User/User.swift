//
//  User.swift
//  RacSwift
//
//  Created by P36348 on 8/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

private let defaultAccessToken: String = GlobalConstant.Client.accessToken

private let defaultUID: String = "default_uid"

class User: Object {
    
    override class func primaryKey() -> String? {
        return "id"
    }
    override class func ignoredProperties() -> [String] {
        return ["creatDate"]
    }
    
    var id:   String = defaultUID
    
    var name: String = ""
    
    var userName: String = ""
    
    var avator:   String = ""
    
    var location: String = ""
    
    var html: String = ""
    
    var bio: String = ""
    
    var createdAt: String = ""
    
    var creatDate: Date? {
        return Date.dribbbleDate(string: createdAt)
    }
    
    var accessToken: String = defaultAccessToken
    
    func setDefault() {
        id = defaultUID
        name = ""
        userName = ""
        avator = ""
        location = ""
        html = ""
        bio  = ""
        accessToken = defaultAccessToken
    }
}

// MARK: - data base
extension Realm {
    func add(user: User) {
        do {
            try write {
                add(user, update: true)
            }
        } catch let error {
            print("fail add user", error)
        }
    }
    
    var sharedUser: User? {
        return objects(User.self).first
    }
    
    
}

extension User {
    
    
    func configureData(with json: JSON) {
        id      = json["id"].stringValue
        name = json["name"].stringValue
        userName = json["username"].stringValue
        avator = json["avatar_url"].stringValue
        location = json["location"].stringValue
        html = json["html_url"].stringValue
        bio = json["bio"].stringValue
        createdAt = json["created_at"].stringValue
    }
}
/**
 {
 "id" : 1,
 "name" : "Dan Cederholm",
 "username" : "simplebits",
 "html_url" : "https://dribbble.com/simplebits",
 "avatar_url" : "https://d13yacurqjgara.cloudfront.net/users/1/avatars/normal/dc.jpg?1371679243",
 "bio" : "Co-founder &amp; designer of <a href=\"https://dribbble.com/dribbble\">@Dribbble</a>. Principal of SimpleBits. Aspiring clawhammer banjoist.",
 "location" : "Salem, MA",
 "links" : {
 "web" : "http://simplebits.com",
 "twitter" : "https://twitter.com/simplebits"
 },
 */


/**
 {
 "avatar_url" = "https://cdn.dribbble.com/assets/avatar-default-aa2eab7684294781f93bc99ad394a0eb3249c5768c21390163c9f55ea8ef83a4.gif";
 bio = "";
 "buckets_count" = 0;
 "buckets_url" = "https://api.dribbble.com/v1/users/894092/buckets";
 "can_upload_shot" = 0;
 "comments_received_count" = 0;
 "created_at" = "2015-07-06T04:30:50Z";
 "followers_count" = 0;
 "followers_url" = "https://api.dribbble.com/v1/users/894092/followers";
 "following_url" = "https://api.dribbble.com/v1/users/894092/following";
 "followings_count" = 6;
 "html_url" = "https://dribbble.com/P36348";
 id = 894092;
 "likes_count" = 1;
 "likes_received_count" = 0;
 "likes_url" = "https://api.dribbble.com/v1/users/894092/likes";
 links =     {
 };
 location = "<null>";
 name = "Oreo Chen";
 pro = 0;
 "projects_count" = 0;
 "projects_url" = "https://api.dribbble.com/v1/users/894092/projects";
 "rebounds_received_count" = 0;
 "shots_count" = 0;
 "shots_url" = "https://api.dribbble.com/v1/users/894092/shots";
 "teams_count" = 0;
 "teams_url" = "https://api.dribbble.com/v1/users/894092/teams";
 type = Prospect;
 "updated_at" = "2016-04-15T17:21:05Z";
 username = P36348;
 }
 
 */
