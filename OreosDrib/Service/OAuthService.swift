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

private struct API {
    static let authorize: String = "https://dribbble.com/oauth/dribbble"
    
    static let token: String = "https://dribbble.com/oauth/token"
}

private let defaultAccessToken: String = GlobalConstant.Client.accessToken

private let accessTokenKey: String = "OAuth_service_access_token_key"

extension OAuthService {
    enum TokenType {
        case authorized, notAuthorized
    }
}

class OAuthService {
    static let shared: OAuthService = OAuthService()
    
    private(set)var accessToken: String = UserDefaults.standard.string(forKey: accessTokenKey) ?? "" {
        didSet {
            (self.rx_accessToken as! PublishSubject).onNext(self.accessToken)
            self.saveToken()
        }
    }
    
    let rx_accessToken: Observable<String> = PublishSubject<String>()
    
    private var oauthswift: OAuth2Swift?
    
    func doOAuth() {
        self.oauthswift = OAuth2Swift(
            consumerKey:    GlobalConstant.Client.id,
            consumerSecret: GlobalConstant.Client.secret,
            authorizeUrl:   GlobalConstant.Authentication.authorizeUrl,
            accessTokenUrl: GlobalConstant.Authentication.accessTokenUrl,
            responseType:   GlobalConstant.Authentication.responseType
        )
        
        let success: OAuth2Swift.TokenSuccessHandler = { [unowned self] (credential, response, params) in
            print("response", response ?? "no value", "credential:", credential, "token:", credential.oauthToken)
            
            self.accessToken = credential.oauthToken
        }
        
        let failure: OAuth2Swift.FailureHandler = { [unowned self] error in
            print("error", error as NSError)
            (self.rx_accessToken as! PublishSubject).onError(error)
        }
        self.oauthswift?.authorize(withCallbackURL: GlobalConstant.Authentication.redirect_uri,
                                   scope: "public+write+comment+upload",
                                   state: generateState(withLength: 20),
                                   success: success,
                                   failure: failure)
    }
    
    /**
     * 重置token
     */
    func clearToken() {
        
        self.accessToken = ""
        
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func saveToken() {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        
        UserDefaults.standard.synchronize()
    }
}
