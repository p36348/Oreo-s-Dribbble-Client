//
//  ShotsController+Views.swift
//  OreosDrib
//
//  Created by P36348 on 23/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

class ShotNormalCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(frame: CGRect.zero)
    }
}

class ShotLargeCell: UICollectionViewCell {
    
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
