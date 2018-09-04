//
//  OAuthService.swift
//  OreosDrib
//
//  Created by P36348 on 1/7/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import OAuthSwift
import RxSwift


private let accessTokenKey: String = "OAuth_service_access_token_key"

class OAuthService {
    
    static let shared: OAuthService = OAuthService()
    
    private(set) var accessToken: String = UserDefaults.standard.string(forKey: accessTokenKey) ?? "" {
        didSet {
            (self.rx_accessToken as! PublishSubject).onNext(self.accessToken)
            (self.rx_hasAccessToken as! PublishSubject).onNext(!self.accessToken.isEmpty)
            self.cacheToken()
        }
    }
    
    let rx_accessToken: Observable<String> = PublishSubject<String>()
    
    let rx_hasAccessToken: Observable<Bool> = PublishSubject<Bool>()
    
    var hasAccessToken: Bool {
        return !self.accessToken.isEmpty
    }
    
    private var oauthswift: OAuth2Swift = OAuth2Swift(consumerKey:    GlobalConstant.Client.id,
                                                      consumerSecret: GlobalConstant.Client.secret,
                                                      authorizeUrl:   GlobalConstant.Authentication.authorizeUrl,
                                                      accessTokenUrl: GlobalConstant.Authentication.accessTokenUrl,
                                                      responseType:   GlobalConstant.Authentication.responseType)
    /// 执行三方认证
    func doOAuth() {
        
        let success: OAuth2Swift.TokenSuccessHandler = { [unowned self] (credential, response, params) in
            print("response", response ?? "no value", "credential:", credential, "token:", credential.oauthToken)
            
            self.accessToken = credential.oauthToken
        }
        
        let failure: OAuth2Swift.FailureHandler = { [unowned self] error in
            print("error", error as NSError)
            (self.rx_accessToken as! PublishSubject).onError(error)
        }
        let state = generateState(withLength: 20)
        self.oauthswift.authorize(withCallbackURL: GlobalConstant.Authentication.redirect_uri,
                                   scope: "public+write+comment+upload",
                                   state: state,
                                   success: success,
                                   failure: failure)
    }
    
    /// 重置token
    func clearToken() {
        
        self.accessToken = ""
        
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func cacheToken() {
        UserDefaults.standard.set(self.accessToken, forKey: accessTokenKey)
        
        UserDefaults.standard.synchronize()
    }
}
