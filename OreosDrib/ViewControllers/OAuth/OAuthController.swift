//
//  OAuthController.swift
//  OreosDrib
//
//  Created by P36348 on 30/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import WebKit

private let redirect_uri = "oreosdrib://oauth-callback"

private func finalUrl(scope: String) -> URL? {
    return URL(string: "https://dribbble.com/oauth/authorize?client_id=\(GlobalConstant.Client.id)&scope=\(scope)")
}


class OAuthController: UIViewController {
    
    fileprivate let progressView: UIProgressView = UIProgressView()
    
    fileprivate let webView: WKWebView = WKWebView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubview()
        
        loadPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubview() {
        
        webView.navigationDelegate = self
        
        webView.uiDelegate = self
        
        view.addSubview(webView)
        
        view.addSubview(progressView)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    
        progressView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view)
        }
    }
    
    private func loadPage() {
        
        guard let _finalUrl = finalUrl(scope: "public+write+comment+upload") else { return }
        
        var request: URLRequest = URLRequest(url: _finalUrl)
        
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        webView.load(request)
    }
}

extension OAuthController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let isOauthCallBack: Bool = navigationAction.request.url?.absoluteString.hasPrefix(redirect_uri) == true
        
        guard isOauthCallBack else { return decisionHandler(WKNavigationActionPolicy.allow) }
        
        if let code = navigationAction.request.url?.query?.components(separatedBy: "=").last {
            let _ = UserService.shared.authorizeToken(code: code)
        }
        
        decisionHandler(WKNavigationActionPolicy.cancel)
    }
}

extension OAuthController: WKUIDelegate {
    
}
