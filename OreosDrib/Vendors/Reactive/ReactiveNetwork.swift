//
//  ReactiveNetwork.swift
//  RacSwift
//
//  Created by P36348 on 8/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import ReactiveSwift
import Result
import SwiftyJSON

struct ReactiveNetwork {
    
    /// 单例
    static let shared: ReactiveNetwork = ReactiveNetwork()
    
    /// 私有初始化函数,避免外部调用
    private init(){}
}

/// Rac信号响应
typealias NetworkSignal = Signal<JSON, ReactiveError>

typealias NetworkResponse = (signal: NetworkSignal, request: DataRequest)


// MARK: - 请求函数
extension ReactiveNetwork {
    
    
    func get(url: URLConvertible, parameters: Parameters? = nil, header: HTTPHeaders? = nil) -> NetworkResponse {
        return doRequest(url: url, method: .get, parameters: parameters, header: header)
    }
    
    
    func post(url: URLConvertible, parameters: Parameters? = nil, header: HTTPHeaders? = nil) -> NetworkResponse{
        return doRequest(url: url, method: .post, parameters: parameters, header: header)
    }
    
    
    func put(url: URLConvertible, parameters: Parameters? = nil, header: HTTPHeaders? = nil) -> NetworkResponse {
        return doRequest(url: url, method: .put, parameters: parameters, header: header)
    }
    
    
    func delete(url: URLConvertible, parameters: Parameters? = nil, header: HTTPHeaders? = nil) -> NetworkResponse {
        return doRequest(url: url, method: .delete, parameters: parameters, header: header)
    }
    
    
    func doRequest(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, header: HTTPHeaders? = nil) -> NetworkResponse {
        
        var _header = ReactiveNetwork.header
        
        if let __header = header { _header += __header }
        
        var _parameters = ReactiveNetwork.commonParams
        
        if let __parameters = parameters { _parameters += __parameters }
        
        let _request: DataRequest = request(url, method: method, parameters: _parameters, encoding: URLEncoding.default, headers: _header)
        
        let signal = NetworkSignal.init({ (observer) -> Disposable? in
            
            _request.responseJSON(completionHandler: { (response) in
                
                print(response.result.value ?? "no value")
                
                guard response.result.isSuccess else {//请求失败
                    observer.send(error: ReactiveError(message: "request failed", code: -1))
                    observer.sendCompleted()
                    return
                }
                
                guard let resultValue = response.result.value else {//请求成功,无数据返回
                    observer.send(value: [:])
                    observer.sendCompleted()
                    return
                }
                
                //有数据,封装成JSON返回
                observer.send(value: JSON(resultValue))
                observer.sendCompleted()
            })
            return nil
        })
        
        return (signal, _request)
    }
}

extension ReactiveNetwork {
    
    /// 约定通用信息
    static var header: HTTPHeaders {
        return ["Authorization": "Bearer " + User.current.accessToken]
    }
    
    /// 约定通用参数
    static var commonParams: [String: Any] = [:]
}
