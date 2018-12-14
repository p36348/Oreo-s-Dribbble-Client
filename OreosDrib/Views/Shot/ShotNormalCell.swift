//
//  ShotNormalCell.swift
//  OreosDrib
//
//  Created by P36348 on 05/09/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import Kingfisher

class ShotNormalCell: UICollectionViewCell {
    let image = AnimatedImageView()
    let title_label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.title_label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.image.needsPrescaling = false
        self.image.runLoopMode = RunLoopMode.defaultRunLoopMode
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.title_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
    }
}

struct NormalShotCellViewModel: Equatable {
    // 4:3
    var imageUrl: String
    
    var image_frame: CGRect
    
    var title: NSAttributedString
    
    var title_frame: CGRect
    
    var size: CGSize
    
    init(shot: Shot, width: CGFloat) {
        self.imageUrl = shot.images?.teaser ?? ""
        self.image_frame = CGRect(x: 0, y: 0, width: width, height: width*3/4)
        self.title = shot.title.attributed()
        let title_height = self.title.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
        self.title_frame = CGRect(x: 0, y: self.image_frame.maxY+10, width: width, height: title_height)
        
        self.size = CGSize(width: width, height: self.title_frame.maxY+10)
    }
    public static func == (lhs: NormalShotCellViewModel, rhs: NormalShotCellViewModel) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.title == rhs.title && lhs.size == rhs.size
    }
}
