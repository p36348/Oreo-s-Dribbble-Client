//
//  ShotDetailController+Section.swift
//  OreosDrib
//
//  Created by P36348 on 23/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension ShotDetailController {
    class ImageSection: UITableViewHeaderFooterView {
        
        private let imageView: AnimatedImageView = AnimatedImageView()
        
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(imageView)
            
            imageView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class ViewModel: ReusableViewModel {
            var viewClass: AnyClass = ImageSection.self
            
            var identifier: String = ImageSection.description()
            
            var height: CGFloat = 0
            
            var URLString: String
            
            init(width: CGFloat,urlString: String) {
                self.height = width * 3 / 4
                self.URLString = urlString
            }
            
            func update(reusableView: UIView) {
                guard let _section = reusableView as? ImageSection else {
                    return
                }
                
                _section.imageView.setImage(urlString: URLString)
            }
        }
    }
}
