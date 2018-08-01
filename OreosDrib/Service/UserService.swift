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
    
    public static let shared: UserService = UserService()
    
    public fileprivate(set) var currentUser: User = User() {
        didSet {
            (self.rx_user as! PublishSubject<User>).onNext(self.currentUser)
        }
    }
    
    public let rx_user: Observable<User> = PublishSubject<User>()
    
    private init(){
        /**
         * 加载本地数据
         */
        loadUserFromDataBase()
    }
    
    private func updateCurrentUser(_ user: User) -> User {
        self.currentUser = user
        return self.currentUser
    }
    
    func logOut() {
        self.currentUser = User()
    }
}

extension UserService {
    func fetchUser() -> Observable<User> {
        return DribbbleAPI.user.rx_request(.authenticatedUser)
            .flatMap{ parseUserFromResponse($0) }
    }
}

extension UserService {
    func updateUser() -> Observable<UserService> {
        // todo: 更新数据库
        return self.fetchUser()
            .map{ [unowned self] in self.currentUser = $0; return self}
    }
}

private func parseUserFromResponse(_ res: Response) -> Observable<User> {
    return res.rx_jsonValue.map { User().setupData(with: $0)}
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
 "avatar_url": "https://cdn.dribbble.com/assets/avatar-default-aa2eab7684294781f93bc99ad394a0eb3249c5768c21390163c9f55ea8ef83a4.gif",
 "bio": "",
 "can_upload_shot": true,
 "created_at": "2015-07-06T00:30:50.187-04:00",
 "followers_count": 0,
 "html_url": "https://dribbble.com/P36348",
 "id": 894092,
 "links": {},
 "location": null,
 "login": "P36348",
 "name": "Oreo Chen",
 "pro": false,
 "type": "User",
 "teams": []
 }
 
 */
