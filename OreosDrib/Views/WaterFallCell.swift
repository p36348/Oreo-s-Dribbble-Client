//
//  WaterFallCell.swift
//  RacSwift
//
//  Created by P36348 on 6/3/17.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import Kingfisher

class WaterFallCell: UICollectionViewCell {
    
    
    // views
    
    let imageView: AnimatedImageView = AnimatedImageView()
    
    let descriptionLabel: UILabel = UILabel()
    
    let corners = makeCorners()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        imageView.kf.indicatorType = .activity
        
        imageView.runLoopMode = .defaultRunLoopMode
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(imageView)
        
        imageView.addSubview(corners.bottomLeft)
        
        imageView.addSubview(corners.topLeft)
        
        imageView.addSubview(corners.bottomRight)
        
        imageView.addSubview(corners.topRight)
        
        corners.topLeft.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
        }
        corners.topRight.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
        }
        corners.bottomLeft.snp.makeConstraints { (make) in
            make.bottom.left.equalTo(0)
        }
        corners.bottomRight.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        guard let _viewModel = viewModel as? ViewModel else { return }
        
        imageView.setImage(urlString: _viewModel.imageUrl)
        
        imageView.frame = _viewModel.imageViewFrame
        
        descriptionLabel.text = _viewModel.descriptionContent
        
        descriptionLabel.frame = _viewModel.descriptionLabelFrame
    }
    
    override func endUpdate() {
        imageView.kf.cancelDownloadTask()
    }

}

extension WaterFallCell {
    
    class ViewModel: CollectionCellViewModel {
        
        var size: CGSize = .zero
        
        var cellClass: AnyClass { return WaterFallCell.self }
        
        var imageUrl: String = ""
        
        var imageViewFrame: CGRect = .zero
        
        var descriptionContent: String = ""
        
        var descriptionLabelFrame: CGRect = .zero
        
        init(size: CGSize, shot: Shot) {
            self.size = size
            imageUrl = shot.images?.normal ?? ""
            
            imageViewFrame = CGRect(x: 0, y: 0, width: size.width, height: size.width * 3 / 4)
            
            descriptionContent = shot.title
            
            descriptionLabelFrame = CGRect(x: 10, y: imageViewFrame.maxY + 10, width: size.width - 20, height: 25)
        }
    }
    
}
