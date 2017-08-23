//
//  UIViewController+Alert.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit


public protocol AlertCompatible: class {
    associatedtype CompatibleType
    var oAlert: CompatibleType { get }
    
}

public final class OAlert<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public extension AlertCompatible {
    public var oAlert: OAlert<Self> {
        get {return OAlert(self)}
    }
}

extension UIViewController: AlertCompatible { }

public extension OAlert where Base: UIViewController {
    func alertActionSheet(title: String? = nil, message: String? = nil, sheetTitles: [String], sheetActions: [(()->Void)]){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        guard sheetTitles.count == sheetActions.count else {
            return
        }
        
        (0..<sheetTitles.count).forEach { (index) in
            controller.addAction(UIAlertAction(title: sheetTitles[index], style: .default, handler: { (action) in
                sheetActions[index]()
            }))
        }
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            controller.dismiss(animated: true, completion: nil)
        }))
        
        if base.navigationController?.topViewController == base || base.presentingViewController == nil{
            base.present(controller, animated: true, completion: nil)
        }
    }
    
    func alert(errorMsg: String) {
        
    }
}
