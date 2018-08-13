//
//  IndexViewController.swift
//  OreosDrib
//
//  Created by P36348 on 13/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift

class IndexViewController: UIViewController {
    
    let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindObservable()
    }
    
    func bindObservable() {
        OAuthService.shared.has_accessToken
            .subscribe(onNext: { has_accessToken in
                
            })
            .disposed(by: self.disposeBag)
    }
    
}
