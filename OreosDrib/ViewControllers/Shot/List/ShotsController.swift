//
//  ShotsController.swift
//  RacSwift
//
//  Created by P36348 on 27/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout
import ESPullToRefresh


class ShotsController: UIViewController {
    
    fileprivate let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: CHTCollectionViewWaterfallLayout())
    
    var collectionViewLayout: CHTCollectionViewWaterfallLayout {
        return collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.bindObservables()
        
        _ = ShotService.shared.reloadShots().subscribe(onNext: { (service) in
            print("service shots:", service.shots)
        }, onError: { err in
            print("err:", err)
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShotsController {
    func setupUI() {
        
    }
    
    func bindObservables() {
        
    }
}
