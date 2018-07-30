////
////  JobService.swift
////  OreosDrib
////
////  Created by P36348 on 7/6/2017.
////  Copyright © 2017 P36348. All rights reserved.
////
//
//import Foundation
//import Alamofire
///// 接口 -http://developer.dribbble.com/v1/jobs/
//private struct API {
//    
//    static let create: String = "/jobs".dribbbleFullUrl
//    
//    static let update: String = "/jobs/:id".dribbbleFullUrl
//    
//    static let show: String = "/jobs/:id".dribbbleFullUrl
//}
//
//struct JobService {
//    
//    static let shared: JobService = JobService()
//    
//    private init(){}
//    
//    func creat(organizationName: String, title: String, location: String, url: String, active: Bool, team: String) -> NetworkResponse {
//        
//        let _parameters = parameters(organizationName: organizationName, title: title, location: location, url: url, active: active, team: team)
//        
//        return ReactiveNetwork.shared.post(url: API.create, parameters: _parameters)
//    }
//    
//    
//    func update(id: String, organizationName: String, title: String, location: String, url: String, active: Bool, team: String) -> NetworkResponse {
//        
//        let _parameters = parameters(organizationName: organizationName, title: title, location: location, url: url, active: active, team: team)
//        
//        return ReactiveNetwork.shared.put(url: API.update.replace(id: id), parameters: _parameters)
//    }
//    
//    
//    func show(id: String) -> NetworkResponse {
//        
//        return ReactiveNetwork.shared.get(url: API.show.replace(id: id))
//    }
//    
//    
//    private func parameters(organizationName: String, title: String, location: String, url: String, active: Bool, team: String) -> Parameters {
//        
//        return ["organization_name": organizationName,
//                "title"            : title,
//                "location"         : location,
//                "url"              : url,
//                "active"           : active,
//                "team"             : team]
//    }
//}
//
//extension String {
//    fileprivate func replace(id: String) -> String {
//        return self.replacingOccurrences(of: ":id", with: id)
//    }
//}
