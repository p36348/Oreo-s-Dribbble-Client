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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize, target: self, action: #selector(clickLeftItem(sender:)))
    }
    
    dynamic private func clickLeftItem(sender: UIBarButtonItem) {
        let isAuth = UserService.shared.currentUser.accessToken != GlobalConstant.Client.accessToken
        
        if isAuth {
            navigationController?.pushViewController(UserInfoController(), animated: true)
        }else {
            present(OAuthController(), animated: true, completion: nil)
        }
    }
    
    private func bindViewModel() {
        UserService.shared.authorizeSignal.observeCompleted {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
