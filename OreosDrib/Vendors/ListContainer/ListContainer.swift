//
//  ListContainer.swift
//  OreosDrib
//
//  Created by P36348 on 26/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit

protocol ListContainer: class {
    
    var listView: UIScrollView { get }
    
    func alert(errorMsg: String) -> Void
}

extension ListContainer where Self: UIViewController {
    
    func alert(errorMsg: String) -> Void {
        
    }
}
