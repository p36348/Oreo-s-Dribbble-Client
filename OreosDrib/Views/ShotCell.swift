//
//  ShotCell.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import Kingfisher

private let kContentPadding: CGFloat = 5

class ShotCell: UICollectionViewCell {
    
    private let imageView: AnimatedImageView! = AnimatedImageView()
    
    private let animatedTag: CALayer! = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        
        animatedTag.isHidden = true
        
        imageView.kf.indicatorType = .activity
        
        imageView.needsPrescaling = false
        
        imageView.runLoopMode = .defaultRunLoopMode
        
        contentView.addSubview(imageView)
        
        contentView.layer.addSublayer(animatedTag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class ViewModel: ReusableViewModel {
        var viewClass: AnyClass = ShotCell.self
        
        var identifier: String = ShotCell.description()
        
        var size: CGSize = CGSize.zero
        
        var hidesAnimated: Bool = false
        
        var imageURL: String = ""
        
        var imageFrame: CGRect = .zero
        
        init(width: CGFloat,shot: Shot) {
            self.hidesAnimated = !shot.animated
            
            self.imageURL = shot.images?.normal ?? ""
            
            let imageWidth: CGFloat = width - kContentPadding * 2
            
            self.imageFrame = CGRect(x: kContentPadding, y: kContentPadding, width: imageWidth, height: imageWidth * 3 / 4)
            
            self.size = CGSize(width: width, height: self.imageFrame.size.height + kContentPadding * 2)
        }
        
        func update(reusableView: UIView) {
            guard let _cell = reusableView as? ShotCell else { return }
            
            _cell.animatedTag.isHidden = self.hidesAnimated
            
            _cell.imageView.setImage(urlString: self.imageURL)
            
            _cell.imageView.frame = self.imageFrame
        }
        
        func endUpdate(reusableView: UIView) {
            guard let _cell = reusableView as? ShotCell else { return }
            
            _cell.imageView.kf.cancelDownloadTask()
        }
    }
}
