//
//  WaterFallController.swift
//  OreosDrib
//
//  Created by P36348 on 26/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

protocol WaterFallControllerDelegate: CollectionCellDelegate {
    
}

class WaterFallController: UIViewController {
    
    var delegate: WaterFallControllerDelegate?
    
    var cellViewModels: [CollectionCellViewModel] = []
    
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: CHTCollectionViewWaterfallLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UICollectionViewDataSource
extension WaterFallController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.cellForItem(at: indexPath) == nil {
            collectionView.register(cellViewModels[indexPath.row].cellClass, forCellWithReuseIdentifier: cellViewModels[indexPath.row].cellClass.description())
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModels[indexPath.row].cellClass.description(), for: indexPath)
            cell.delegate = delegate
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
    }
}
