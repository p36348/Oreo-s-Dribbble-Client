//
//  ShotLargeCell.swift
//  OreosDrib
//
//  Created by P36348 on 05/09/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import Kingfisher

class ShotLargeCell: UICollectionViewCell {
    let image = UIImageView()
    let view_count_label = UILabel()
    let comments_count_label = UILabel()
    let likes_count_label = UILabel()
    let title_label = UILabel()
    let comment_label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.title_label.numberOfLines = 0
        self.comment_label.numberOfLines = 0
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.view_count_label)
        self.contentView.addSubview(self.comments_count_label)
        self.contentView.addSubview(self.likes_count_label)
        self.contentView.addSubview(self.title_label)
        self.contentView.addSubview(self.comment_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(frame: CGRect.zero)
    }
}

struct ShotLargeCellViewModel: Equatable {
    // 4:3
    var imageUrl: String
    
    var image_frame: CGRect
    
    var title: NSAttributedString
    
    var title_frame: CGRect
    
    var comment: NSAttributedString
    
    var comment_frame: CGRect
    
    var size: CGSize
    
    init(shot: Shot, width: CGFloat) {
        self.imageUrl = shot.images?.teaser ?? ""
        self.image_frame = CGRect(x: 0, y: 0, width: width, height: width*3/4)
        
        self.title = shot.title.attributed()
        let title_height = self.title.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
        self.title_frame = CGRect(x: 0, y: self.image_frame.maxY+10, width: width, height: title_height)
        
        self.comment = shot.comment.attributed()
        let comment_height = self.comment.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
        self.comment_frame = CGRect(x: 0, y: self.title_frame.maxY+10, width: width, height: comment_height)
        
        self.size = CGSize(width: width, height: self.title_frame.maxY+10)
    }
    
    public static func == (lhs: ShotLargeCellViewModel, rhs: ShotLargeCellViewModel) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.title == rhs.title && lhs.size == rhs.size
    }
}
