//
//  UserService.swift
//  RacSwift
//
//  Created by P36348 on 25/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON
import ReactiveSwift
import Alamofire
import Result
import RealmSwift

/// 接口 -http://developer.dribbble.com/v1/users/
private struct API {
    
    static let signIn: String = ""
    
    static let authenticatedUser: String = "/user".dribbbleFullUrl
    
    static let authenticatedUserBuckets: String = "/user/buckets".dribbbleFullUrl
    
    static let authenticatedFollowers: String = "/user/followers".dribbbleFullUrl
    
    static let authenticatedFollowing: String = "/user/following"
    
    static let singleUser: String = "/users/:user".dribbbleFullUrl
    
    static let userBuckets: String = "/users/:user/buckets".dribbbleFullUrl
    
    static let followers: String = "/users/:user/followers".dribbbleFullUrl
    
    static let following: String = "/users/:user/following"
    
}

private let currentUIDKey: String = "user_service_current_uid_key"

class UserService {
    
    static let shared: UserService = UserService()
    
    var currentUser: User { return _currentUser }
    
    fileprivate var _currentUser: User = User()
    
    var (userInfoSignal, userInfoObserver) = Signal<User, NoError>.pipe()
    
    private var signInRequest: DataRequest?
    
    private init(){
        /**
         * 加载本地数据
         */
        loadUserFromDataBase()
    }
    
    func sign(userName: String, password: String) -> NetworkResponse {
        
        cancelSignIn()
        
        let response: NetworkResponse = ReactiveNetwork.shared.post(url: API.signIn, parameters: ["userName": userName, "password": password])
        
        response.signal.observeResult { (result) in //处理结果
            guard let _result = result.value else { return }
            /*
             更新User模型数据
             */
            self.currentUser.configureData(with: _result)
        }
        
        signInRequest = response.request
        
        return response
    }
    
    func cancelSignIn() {
        signInRequest?.cancel()
        signInRequest = nil
    }
    
    func get(user: String = "") -> NetworkResponse {
        return ReactiveNetwork.shared.get(url: API.singleUser.replace(user: user))
    }
    
    func getCurrentUser() -> NetworkResponse {
        let response: NetworkResponse = ReactiveNetwork.shared.get(url: API.authenticatedUser)
        response.signal.observeResult { (result) in
            guard let _json = result.value else { return }
            /*
             更新User模型数据
             */
            self.updateCurrentUser(with: _json)
        }
        return response
    }
    
    func buckets(user: String = "") -> NetworkResponse {
        guard user.isEmpty else {
            return ReactiveNetwork.shared.get(url: API.authenticatedUserBuckets)
        }
        return ReactiveNetwork.shared.get(url: API.userBuckets.replace(user: user))
    }
    
    func followers(user: String = "") -> NetworkResponse {
        guard user.isEmpty else {
            return ReactiveNetwork.shared.get(url: API.authenticatedFollowers)
        }
        return ReactiveNetwork.shared.get(url: API.followers.replace(user: user))
    }
    
    func logOut() {
        _currentUser = User()
    }
}


/**
 * 通过UserDefault存放唯一登录的uid, uid为加载对应数据库的依据, user数据存于对应的数据库当中
 */

// MARK: - User数据本地化处理
extension UserService {
    func updateCurrentUser(with json: JSON) {
        
        let _id = json["id"].stringValue
        
        let realm = RealmManager.shared.dataBase(of: _id)
        
        do {
            try realm.write {
                self.currentUser.configureData(with: json)
                
                UserDefaults.standard.set(currentUser.id, forKey: currentUIDKey)
                
                UserDefaults.standard.synchronize()
                
                self.userInfoObserver.send(value: currentUser)
            }
        }catch let error {
            print(error)
        }
    }
    
    func loadUserFromDataBase() {
        guard let _uid = UserDefaults.standard.string(forKey: currentUIDKey) else { return }
        
        guard let _user = RealmManager.shared.dataBase(of: _uid).sharedUser else { return }
        
        _currentUser = _user
    }
}

extension String {
    fileprivate func replace(user: String) -> String {
        return self.replacingOccurrences(of: ":user", with: user)
    }
}

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
