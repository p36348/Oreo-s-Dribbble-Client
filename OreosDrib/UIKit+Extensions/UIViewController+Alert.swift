//
//  UIViewController+Alert.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import Toast_Swift

public protocol AlertCompatible: class {
    associatedtype CompatibleType
    var oreo: CompatibleType { get }
    
}

public final class Oreo<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public extension AlertCompatible {
    public var oreo: Oreo<Self> {
        get {return Oreo(self)}
    }
}

extension UIViewController: AlertCompatible { }

public extension Oreo where Base: UIViewController {
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
    
    func toast(message: String) {
        base.view.makeToast(message, duration: 1.5, position: ToastPosition.center)
    }
}
