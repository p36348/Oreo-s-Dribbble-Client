//
//  WKWebView+Handle.swift
//  OreosDrib
//
//  Created by P36348 on 23/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import WebKit
extension WKWebView {
    
    /// 返回一个注入当前用户jwtToken的webView
    ///
    /// - Parameters:
    ///   - frame: webView的矩阵
    ///   - token: 用户token
    /// - Returns: webview实例
    static func jwtTokenWebview(frame: CGRect, jwtToken: String) ->WKWebView{
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(WKUserScript(source: "window.info = {\"jwtToken\" : \"\(jwtToken)\"}", injectionTime: .atDocumentStart, forMainFrameOnly: false))
        let _webView = WKWebView(frame: frame, configuration: configuration)
        return _webView
    }
}
