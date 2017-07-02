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
import OAuthSwift

private struct API {
    static let authorize: String = "https://dribbble.com/oauth/dribbble"
    
    static let token: String = "https://dribbble.com/oauth/token"
}

class OAuthService {
    static let shared: OAuthService = OAuthService()
    
    let (oAuthSignal, oAuthObserver) = Signal<Void, NSError>.pipe()
    
    private init(){}
    
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
            
            UserService.shared.currentUser.accessToken = credential.oauthToken
            
            self.oAuthObserver.sendCompleted()
        }
        
        let failure: OAuthSwift.FailureHandler = { error in
        print("error", error as NSError)
        
        self.oAuthObserver.send(error: error as NSError)
        }
        oauthswift.authorize(withCallbackURL: "OreosDrib://oauth-callback/dribbble", scope: "public+write+comment+upload", state: "", success: success, failure: failure)
    }
}
