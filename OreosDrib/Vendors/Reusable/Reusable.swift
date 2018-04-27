//
//  Reusable.swift
//  OreosDrib
//
//  Created by P36348 on 23/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableViewModel: class {
    
    var viewClass: AnyClass {get}
    
    var identifier: String {get}
    
    var size: CGSize {get}
    
    var height: CGFloat {get}
    
    func update(reusableView: UIView)
    
    func endUpdate(reusableView: UIView)
}

extension ReusableViewModel {
    var size: CGSize { return CGSize.zero }
    
    var height: CGFloat { return 0 }
    
    func update(reusableView: UIView) {
    
    }
    
    func endUpdate(reusableView: UIView) {
        
    }
}

protocol ReusableViewDelegate {
    
}
