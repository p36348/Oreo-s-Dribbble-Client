//
//  ShotsController+Views.swift
//  OreosDrib
//
//  Created by P36348 on 23/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import Kingfisher
class ShotNormalCell: UICollectionViewCell {
//    let image = AnimatedImageView()
    let image = UIImageView()
    let title_label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
//        self.image.needsPrescaling = false
//        self.image.runLoopMode = RunLoopMode.defaultRunLoopMode
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.title_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(frame: CGRect.zero)
    }
}

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


//class ShotNormalCellNode: ASCellNode {
//
//    var image: ASImageNode = ASImageNode()
//
//    var like: ASButtonNode = ASButtonNode()
//
//    var tag: ASImageNode = ASImageNode()
//
//    override init() {
//        super.init()
//        self.backgroundColor = UIColor.white
//    }
//}
//
//class ShotLargeCellNode: ASCellNode {
//    var image: ASImageNode = ASImageNode()
//
//    var like: ASButtonNode = ASButtonNode()
//
//    var tag: ASImageNode = ASImageNode()
//
//    var title: ASTextNode = ASTextNode()
//    override init() {
//        super.init()
//        self.backgroundColor = UIColor.white
//    }
//
//    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        return ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 5, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.center, flexWrap: ASStackLayoutFlexWrap.wrap, alignContent: ASStackLayoutAlignContent.start, children: [self.image, self.like, self.tag, self.title])
//    }
//}
