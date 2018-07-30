//
//  TabBarController.swift
//  OreosDrib
//
//  Created by P36348 on 29/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubviews() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.tintColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SettingButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickLeftItem(sender:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(clickRightItem(sender:)))
        
        tabBar.tintColor = UIColor.Dribbble.pink
    }
    
    @objc func clickLeftItem(sender: UIBarButtonItem) {
        let isAuth = OAuthService.shared.accessToken != GlobalConstant.Client.accessToken
        
        if isAuth {
            navigationController?.pushViewController(UserInfoController(), animated: true)
        }else {
            present(OAuthController(), animated: true, completion: nil)
        }
    }
    
    @objc func clickRightItem(sender: UIBarButtonItem) {
//        navigationController?.pushViewController(SearchController(), animated: true)
    }
    
    private func bindViewModel() {
//        OAuthService.shared.authorizeTokenSignal.observeResult({ (result) in
//            guard let _value = result.value else { return }
//
//            self.handle(authorized: _value == .authorized)
//        })
    }
    
    private func handle(authorized: Bool) {
        if authorized {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
