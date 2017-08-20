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
    
    let autherLabel: UILabel = UILabel()
    
    let corners = makeCorners()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        imageView.kf.indicatorType = .activity
        
        imageView.needsPrescaling = false

        imageView.runLoopMode = .defaultRunLoopMode
        
        descriptionLabel.textColor = UIColor.Dribbble.charcoal
        
//        descriptionLabel.backgroundColor = UIColor.white
        
        descriptionLabel.font = UIFont.contentNormal
        
        descriptionLabel.numberOfLines = 0
        
        autherLabel.textColor = UIColor.Dribbble.slate
        
//        autherLabel.backgroundColor = UIColor.white
        
        autherLabel.font = UIFont.contentNormal
        
        autherLabel.textAlignment = .right
        
        autherLabel.numberOfLines = 0
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(autherLabel)
        
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
    
    override func prepare() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        autherLabel.text = nil
        descriptionLabel.text = nil
    }
    
    override func update() {
        guard let _viewModel = viewModel as? ViewModel else { return }
        
        imageView.setImage(urlString: _viewModel.imageUrl)
        
        if _viewModel.imageViewFrame != imageView.frame { imageView.frame = _viewModel.imageViewFrame }
        
        descriptionLabel.text = _viewModel.descriptionContent
        
        descriptionLabel.frame = _viewModel.descriptionLabelFrame
        
        autherLabel.text = _viewModel.autherContent
        
        autherLabel.frame = _viewModel.autherFrame
    }
    
    override func endUpdate() {
        imageView.kf.cancelDownloadTask()
    }

}

private let hPadding: CGFloat = 5

private let vPadding: CGFloat = 10

extension WaterFallCell {
    
    class ViewModel: CollectionCellViewModel {
        
        var size: CGSize = .zero
        
        var cellClass: AnyClass { return WaterFallCell.self }
        
        var imageUrl: String = ""
        
        var imageViewFrame: CGRect = .zero
        
        var descriptionContent: String = ""
        
        var descriptionLabelFrame: CGRect = .zero
        
        var autherContent: String = ""
        
        var autherFrame: CGRect = .zero
        
        init(width: CGFloat, shot: Shot) {
            imageUrl = shot.images?.normal ?? ""
            
            imageViewFrame = CGRect(x: 0, y: 0, width: width, height: width * 3 / 4)
            
            descriptionContent = shot.title
            
            let descSize: CGSize = UIFont.contentNormal.size(of: shot.title, maxWidth: width - hPadding * 2)
            
            descriptionLabelFrame = CGRect(x: hPadding, y: imageViewFrame.maxY + vPadding, width: descSize.width, height: descSize.height)
            
            autherContent = shot.user.name
            
            let authSize: CGSize = UIFont.contentNormal.size(of: autherContent, maxWidth: width - hPadding * 2)
            
            autherFrame = CGRect(x: hPadding + (width - hPadding - authSize.width), y: descriptionLabelFrame.maxY + vPadding, width: authSize.width, height: authSize.height)
            
            size = CGSize(width: width, height: autherFrame.maxY + vPadding)
        }
    }
    
}
