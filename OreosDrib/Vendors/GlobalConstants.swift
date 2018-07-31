//
//  GlobalConstants.swift
//  OreosDrib
//
//  Created by P36348 on 24/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation


struct GlobalConstant {
    
    struct Client {
        
        static let accessToken: String = ""
        
        static let secret: String = "313f94f7c9cda7261b4464ece1b805364000756e1475a1cbfbef0658753785ee"
        
        static let id: String = "4108475e86963711a05aed6c36a2877523256d1250c299e7a626474e80b64128"
    }
    
    struct Authentication {
        static let redirect_uri = "oreosdrib://oauth-callback/dribbble"
        static let authorizeUrl =   "https://dribbble.com/oauth/authorize"
        static let accessTokenUrl = "https://dribbble.com/oauth/token"
        static let responseType =  "code"
    }
    
}
