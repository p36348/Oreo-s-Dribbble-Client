//
//  UserService.swift
//  RacSwift
//
//  Created by P36348 on 25/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RealmSwift
import RxSwift
import Moya

private let currentUIDKey: String = "user_service_current_uid_key"

public class UserService {
    
    typealias selfClass = UserService
    
    static let shared: UserService = UserService()
    
    /// 外部get 内部带set
    public fileprivate(set) var currentUser: User = User() {
        didSet {
            (self.rx_user as! PublishSubject<User>).onNext(self.currentUser)
        }
    }
    
    let rx_user: Observable<User> = PublishSubject<User>()
    
    private init(){
        /**
         * 加载本地数据
         */
        loadUserFromDataBase()
    }
    
    
    func fetchDetail(uid: String = "") -> Observable<User> {
        
        if uid.isEmpty {
            return DribbbleAPI.user
                .rx.request(.authenticatedUser).asObservable()
                .flatMap{selfClass.parseUserFromResponse($0)}
                .map{[unowned self] in self.updateCurrentUser($0)}
        } else {
            return DribbbleAPI.user.rx.request(.singleUser(uid: uid)).asObservable().flatMap{selfClass.parseUserFromResponse($0)}
        }
        
    }
    
    func buckets(uid: String = "") -> Observable<Response> {
        return DribbbleAPI.user.rx.request(uid.isEmpty ? .authenticatedUserBuckets : .userBuckets(uid: uid)).asObservable()
    }
    
    func followers(uid: String = "") -> Observable<Response> {
        return DribbbleAPI.user.rx.request(uid.isEmpty ? .authenticatedFollowers : .followers(uid: uid)).asObservable()
    }
    
    func logOut() {
        self.currentUser = User()
    }
}

extension UserService {
    static func parseUserFromResponse(_ res: Response) -> Observable<User> {
        return res.rx_jsonValue.map { User().setupData(with: $0)}
    }
}


/**
 * 通过UserDefault存放唯一登录的uid, uid为加载对应数据库的依据, user数据存于对应的数据库当中
 */

// MARK: - User数据本地化处理
extension UserService {
//    func updateCurrentUser(with json: JSON) {
//
//        let _id = json["id"].stringValue
//
//        let realm = RealmManager.shared.dataBase(of: _id)
//
//        do {
//            try realm.write {
//                self.currentUser.configureData(with: json)
//
//                UserDefaults.standard.set(currentUser.id, forKey: currentUIDKey)
//
//                UserDefaults.standard.synchronize()
//
////                self.userInfoObserver.send(value: currentUser)
//            }
//        }catch let error {
//            print(error)
//        }
//    }
    
    func updateCurrentUser(_ user: User) -> User {
        self.currentUser = user
        return self.currentUser
    }
    
    func loadUserFromDataBase() {
        guard let _uid = UserDefaults.standard.string(forKey: currentUIDKey) else { return }
        
        guard let _user = RealmManager.shared.dataBase(of: _uid).sharedUser else { return }
        
        currentUser = _user
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
