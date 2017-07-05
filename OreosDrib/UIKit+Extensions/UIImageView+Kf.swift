//
//  UIImageView+kf.swift
//  OreosDrib
//
//  Created by P36348 on 27/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
extension UIImageView {
    
    func setImage(urlString: String, placeholder: UIImage? = nil) {
        guard let _url = URL(string: urlString) else {return}
        
        self.kf.setImage(with: _url, placeholder: placeholder)
    }
}
