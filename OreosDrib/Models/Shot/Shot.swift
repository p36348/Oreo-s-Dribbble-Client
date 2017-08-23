//
//  Shot.swift
//  OreosDrib
//
//  Created by P36348 on 25/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Shot {
    var id: String = ""
    var title: String = ""
    var descriptionStr: String = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    var animated: Bool = false
    
    
    var images: ImageInfo?
    var views: UInt = 0
    var likes: UInt = 0
    var attachments: UInt = 0
    var rebounds: UInt = 0
    var user: User
    var team: Team
    
    init(with json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        descriptionStr = json["description"].stringValue
        width = CGFloat(json["width"].floatValue)
        height = CGFloat(json["height"].floatValue)
        animated = json["animated"].boolValue
        images = ImageInfo(with: json["images"])
        views = json["views"].uIntValue
        likes = json["likes"].uIntValue
        attachments = json["attachments"].uIntValue
        rebounds = json["rebounds"].uIntValue
        
        user = User()
        user.configureData(with: json["user"])
        
        team = Team(json: json["team"])
    }
}

extension Shot {
    struct ImageInfo {
        var hidpi:  String?
        var normal: String?
        var teaser: String?
        init(with json: JSON) {
            hidpi = json["hidpi"].string
            
            normal = json["normal"].string
            
            teaser = json["teaser"].string
        }
    }
}

/**
 {
 "id" : 471756,
 "title" : "Sasquatch",
 "description" : "<p>Quick, messy, five minute sketch of something that might become a fictional something.</p>",
 "width" : 400,
 "height" : 300,
 "images" : {
 "hidpi" : null,
 "normal" : "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/471756/sasquatch.png",
 "teaser" : "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/471756/sasquatch_teaser.png"
 },
 "views_count" : 4372,
 "likes_count" : 149,
 "comments_count" : 27,
 "attachments_count" : 0,
 "rebounds_count" : 2,
 "buckets_count" : 8,
 "created_at" : "2012-03-15T01:52:33Z",
 "updated_at" : "2012-03-15T02:12:57Z",
 "html_url" : "https://dribbble.com/shots/471756-Sasquatch",
 "attachments_url" : "https://api.dribbble.com/v1/shots/471756/attachments",
 "buckets_url" : "https://api.dribbble.com/v1/shots/471756/buckets",
 "comments_url" : "https://api.dribbble.com/v1/shots/471756/comments",
 "likes_url" : "https://api.dribbble.com/v1/shots/471756/likes",
 "projects_url" : "https://api.dribbble.com/v1/shots/471756/projects",
 "rebounds_url" : "https://api.dribbble.com/v1/shots/471756/rebounds",
 "animated" : false,
 "tags" : [
 "fiction",
 "sasquatch",
 "sketch",
 "wip"
 ],
 "user" : {
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
 "buckets_count" : 10,
 "comments_received_count" : 3395,
 "followers_count" : 29262,
 "followings_count" : 1728,
 "likes_count" : 34954,
 "likes_received_count" : 27568,
 "projects_count" : 8,
 "rebounds_received_count" : 504,
 "shots_count" : 214,
 "teams_count" : 1,
 "can_upload_shot" : true,
 "type" : "Player",
 "pro" : true,
 "buckets_url" : "https://dribbble.com/v1/users/1/buckets",
 "followers_url" : "https://dribbble.com/v1/users/1/followers",
 "following_url" : "https://dribbble.com/v1/users/1/following",
 "likes_url" : "https://dribbble.com/v1/users/1/likes",
 "shots_url" : "https://dribbble.com/v1/users/1/shots",
 "teams_url" : "https://dribbble.com/v1/users/1/teams",
 "created_at" : "2009-07-08T02:51:22Z",
 "updated_at" : "2014-02-22T17:10:33Z"
 },
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
 },
 "buckets_count" : 1,
 "comments_received_count" : 2037,
 "followers_count" : 25011,
 "followings_count" : 6120,
 "likes_count" : 44,
 "likes_received_count" : 15811,
 "members_count" : 7,
 "projects_count" : 4,
 "rebounds_received_count" : 416,
 "shots_count" : 91,
 "can_upload_shot" : true,
 "type" : "Team",
 "pro" : false,
 "buckets_url" : "https://dribbble.com/v1/users/39/buckets",
 "followers_url" : "https://dribbble.com/v1/users/39/followers",
 "following_url" : "https://dribbble.com/v1/users/39/following",
 "likes_url" : "https://dribbble.com/v1/users/39/likes",
 "members_url" : "https://dribbble.com/v1/teams/39/members",
 "shots_url" : "https://dribbble.com/v1/users/39/shots",
 "team_shots_url" : "https://dribbble.com/v1/users/39/teams",
 "created_at" : "2009-08-18T18:34:31Z",
 "updated_at" : "2014-02-14T22:32:11Z"
 }
 }
 */
