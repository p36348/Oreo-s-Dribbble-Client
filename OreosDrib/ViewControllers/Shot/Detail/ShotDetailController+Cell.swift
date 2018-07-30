//
//  ShotDetailController+Cell.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

extension ShotDetailController {
    class DescriptionCell: UITableViewCell {
        let textView: UITextView = UITextView()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.backgroundColor = UIColor.white
            
            textView.isEditable = false
            
            textView.isScrollEnabled = false
            
            textView.backgroundColor = .white
            
            textView.textContainerInset = .zero
            
            contentView.addSubview(textView)
            
            textView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class ViewModel: ReusableViewModel {
            var viewClass: AnyClass = DescriptionCell.self
            
            var identifier: String = DescriptionCell.description()
            
            var height: CGFloat = 0
            
            var parser: HTMLParser = HTMLParser()
            
            init(string: String) {
                parser.parse(html: string)
                
                self.height = parser.attrString.boundingRect(with: CGSize(width: kScreenWidth, height: CGFloat(MAXFLOAT)),
                                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                             context: nil).height
                
            }
            func update(reusableView: UIView) {
                guard let _cell = reusableView as? DescriptionCell else { return }
                
                _cell.textView.attributedText = self.parser.attrString
            }
        }
    }
    
    class AuthorInfoCell: UITableViewCell {
        
        private let avatorNode: ASNetworkImageNode = ASNetworkImageNode()
        
        private let titleNode: ASTextNode = ASTextNode()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            selectionStyle = .none
            
            contentView.addSubnode(avatorNode)
            contentView.addSubnode(titleNode)
            
            avatorNode.frame = ViewModel.avatorFrame
            avatorNode.cornerRadius = ViewModel.avatorWidth / 2
            avatorNode.clipsToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class ViewModel: ReusableViewModel {
            var viewClass: AnyClass = AuthorInfoCell.self
            
            var identifier: String = AuthorInfoCell.description()
            
            var height: CGFloat = 100
            
            var avatorURL: URL?
            
            static var avatorWidth: CGFloat = 40
            
            static var avatorFrame: CGRect = CGRect(x: 10, y: 10, width: ViewModel.avatorWidth, height: ViewModel.avatorWidth)
            
            var attributeString: NSAttributedString
            
            var textFrame: CGRect
            
            init(shot: Shot) {
                
                avatorURL = URL(string: shot.user.avator)
                
                let _attributeString = NSMutableAttributedString()
                
                _attributeString.append(NSAttributedString(string: shot.title + "\n",
                                                           attributes: [NSAttributedStringKey.font: UIFont.title]))
                
                _attributeString.append(NSAttributedString(string: "by ",
                                                           attributes: [NSAttributedStringKey.font: UIFont.subTitle]))
                
                let byUser: Bool = shot.user.name != ""
                
                let author = byUser ? shot.user.name : shot.team.name
                
                _attributeString.append(NSAttributedString(string: author,
                                                           attributes: [NSAttributedStringKey.font: UIFont.subTitleBold, NSAttributedStringKey.foregroundColor: UIColor.Dribbble.linkBlue]))
                
                let hasCompany: Bool = shot.team.name != ""
                
                if (byUser && hasCompany) {
                    _attributeString.append(NSAttributedString(string: " in ",
                                                               attributes: [NSAttributedStringKey.font: UIFont.subTitle]))
                    
                    _attributeString.append(NSAttributedString(string: shot.team.name,
                                                               attributes: [NSAttributedStringKey.font: UIFont.subTitleBold, NSAttributedStringKey.foregroundColor: UIColor.Dribbble.linkBlue]))
                }
                
                attributeString = _attributeString
                
                let _size = _attributeString.boundingRect(with: CGSize(width: kScreenWidth - ViewModel.avatorFrame.width - 30, height: CGFloat(MAXFLOAT)),
                                                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                     context: nil).size
                self.textFrame = CGRect(origin: CGPoint(x: ViewModel.avatorFrame.maxX + 10, y: ViewModel.avatorFrame.origin.y), size: _size)
                
                self.height = max(self.textFrame.height, ViewModel.avatorFrame.width) + 20
            }
            
            func update(reusableView: UIView) {
                guard let _cell = reusableView as? AuthorInfoCell else { return }
                
                _cell.avatorNode.url = self.avatorURL
                
                _cell.titleNode.backgroundColor = .white
                
                _cell.titleNode.attributedText = self.attributeString
                
                _cell.titleNode.frame = self.textFrame
            }
        }
    }
}
