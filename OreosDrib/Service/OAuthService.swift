//
//  OAuthService.swift
//  OreosDrib
//
//  Created by P36348 on 1/7/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import SwiftyJSON
import Alamofire
import OAuthSwift

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
    
    var accessToken: String = defaultAccessToken
    
    let (authorizeTokenSignal, authorizeTokenObserver) = Signal<TokenType, NSError>.pipe()
    
    private init(){
        accessToken = UserDefaults.standard.string(forKey: accessTokenKey) ?? defaultAccessToken
    }
    
    func doOAuth() {
        let oauthswift = OAuth2Swift(
            consumerKey:    GlobalConstant.Client.id,
            consumerSecret: GlobalConstant.Client.secret,
            authorizeUrl:   "https://dribbble.com/oauth/authorize",
            accessTokenUrl: "https://dribbble.com/oauth/token",
            responseType:   "code"
        )
        
        let success: OAuthSwift.TokenSuccessHandler = { (credential, response, params) in
            print("response", response ?? "no value")
            
            self.accessToken = credential.oauthToken
            
            self.authorizeTokenObserver.sendCompleted()
        }
        
        let failure: OAuthSwift.FailureHandler = { error in
        print("error", error as NSError)
        
        self.authorizeTokenObserver.send(error: error as NSError)
        }
        oauthswift.authorize(withCallbackURL: "OreosDrib://oauth-callback/dribbble", scope: "public+write+comment+upload", state: "", success: success, failure: failure)
    }
    
    func authorizeToken(code: String) -> NetworkResponse {
        let params: Parameters = ["code": code, "client_id": GlobalConstant.Client.id, "client_secret": GlobalConstant.Client.secret]
        
        let response: NetworkResponse = ReactiveNetwork.shared.post(url: API.token, parameters: params)
        
        response.signal.observeResult { (result) in
            
            guard let _value = result.value else { return }
            
            self.accessToken = _value["access_token"].stringValue
            
            self.saveToken()
            
            self.authorizeTokenObserver.send(value: OAuthService.TokenType.authorized)
        }
        
        return response
    }
    
    /**
     * 重置token
     */
    func resetToken() {
        accessToken = defaultAccessToken
        
        authorizeTokenObserver.send(value: OAuthService.TokenType.notAuthorized)
        
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        
        UserDefaults.standard.synchronize()
    }
}

extension OAuthService {
    fileprivate func saveToken() {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        
        UserDefaults.standard.synchronize()
    }
}
