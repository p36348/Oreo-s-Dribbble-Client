//
//  UIImageView+Kf.swift
//  OreosDrib
//
//  Created by P36348 on 27/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(urlString: String) {
        guard let _url = URL(string: urlString) else {return}
        self.kf.setImage(with: _url)
    }
}
