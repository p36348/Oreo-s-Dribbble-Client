//
//  ShotsController+Views.swift
//  OreosDrib
//
//  Created by P36348 on 23/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit

class ShotSectionHeader: UICollectionReusableView {
    
    var viewModel: ViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShotSectionHeader {
    class ViewModel {
    
    }
}
