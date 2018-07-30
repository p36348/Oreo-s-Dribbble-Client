//
//  OAuthController.swift
//  OreosDrib
//
//  Created by P36348 on 30/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import WebKit

private let redirect_uri = "OreosDrib://oauth-callback/dribbble"

private let host: String = "oauth-callback"

private func finalUrl(scope: String) -> URL? {
    return URL(string: "https://dribbble.com/oauth/authorize?client_id=\(GlobalConstant.Client.id)&scope=\(scope)")
}


class OAuthController: UIViewController {
    
    fileprivate let dismissButton: UIButton = UIButton(type: UIButtonType.custom)
    
    fileprivate let progressView: UIProgressView = UIProgressView()
    
    fileprivate let webView: WKWebView = WKWebView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubview()
        
        cleanCache()
        
        loadPage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubview() {
        
        webView.navigationDelegate = self
        
        webView.uiDelegate = self
        
        dismissButton.addTarget(self, action: NSSelectorFromString("dismiss"), for: UIControlEvents.touchUpInside)
        
        dismissButton.setImage(#imageLiteral(resourceName: "DismissButton"), for: .normal)
        
        view.addSubview(webView)
        
        view.addSubview(progressView)
        
        view.addSubview(dismissButton)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    
        progressView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(5)
            
            make.centerY.equalTo(view.snp.top).offset(44)
            
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
    }
    
    private func loadPage() {
        
        guard let _finalUrl = finalUrl(scope: "public+write+comment+upload") else { return }
        
        var request: URLRequest = URLRequest(url: _finalUrl)
        
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        webView.load(request)
    }
    
    private func cleanCache(){
        if #available(iOS 9, *) {
            WKWebsiteDataStore.default().removeData(ofTypes: Set(arrayLiteral: WKWebsiteDataTypeCookies), modifiedSince: Date(timeIntervalSince1970: 0)) {
                //TODO: handle
            }
        }else {
            let libraryDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.allLibrariesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)[0]
            let bundleId   = Bundle.main.bundleIdentifier!
            let webkitFolderInLib = libraryDir + "/WebKit"
            let webKitFolderInCaches = libraryDir + "/Caches/" + bundleId + "/WebKit"
            
            _ = try? FileManager.default.removeItem(atPath: webkitFolderInLib)
            _ = try? FileManager.default.removeItem(atPath: webKitFolderInCaches)
        }
    }
    
     func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension OAuthController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let isOauthCallBack: Bool = navigationAction.request.url?.host == host
        
        guard isOauthCallBack else { return decisionHandler(WKNavigationActionPolicy.allow) }
        
        if let code = navigationAction.request.url?.query?.components(separatedBy: "=").last {
            let _ = OAuthService.shared.authorizeToken(code: code)
        }
        
        decisionHandler(WKNavigationActionPolicy.cancel)
    }
}

extension OAuthController: WKUIDelegate {
    
}
