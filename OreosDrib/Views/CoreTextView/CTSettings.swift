//
//  CTSettings.swift
//  OreosDrib
//
//  Created by P36348 on 12/7/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import Foundation

class CTSettings {
    //1
    // MARK: - Properties
    let margin: CGFloat = 20
    var columnsPerPage: CGFloat!
    var pageRect: CGRect!
    var columnRect: CGRect!
    
    // MARK: - Initializers
    init() {
        //2
        columnsPerPage = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
        //3
        pageRect = UIScreen.main.bounds.insetBy(dx: margin, dy: margin)
        //4
        columnRect = CGRect(x: 0,
                            y: 0,
                            width: pageRect.width / columnsPerPage,
                            height: pageRect.height).insetBy(dx: margin, dy: margin)
    }
}
