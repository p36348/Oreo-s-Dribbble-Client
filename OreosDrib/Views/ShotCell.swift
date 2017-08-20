//
//  ShotCell.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ShotCell: UICollectionViewCell {
    
    private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageNode.shouldCacheImage = false
        
        contentView.addSubnode(imageNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        
        guard let _viewModel = viewModel as? ViewModel else {return}
        
        imageNode.setURL(_viewModel.imageURL, resetToDefault: false)
        
        imageNode.frame = _viewModel.imageFrame
    }
    
    class ViewModel: CollectionCellViewModel {
        var cellClass: AnyClass = ShotCell.self
        
        var size: CGSize = CGSize.zero
        
        var imageURL: URL?
        
        var imageFrame: CGRect = .zero
        
        init(shot: Shot) {
            
        }
    }
}
