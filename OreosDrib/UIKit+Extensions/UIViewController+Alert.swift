//
//  UIViewController+Alert.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit


// MARK: - Alert
public extension UIViewController {
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
        
        if self.navigationController?.topViewController == self || self.presentingViewController == nil{
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func alert(errorMsg: String) {
        let controller = UIAlertController(title: "Notice", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(controller, animated: true, completion: nil)
    }
}


import Toast_Swift

// MARK: - Toast
public extension UIViewController {
    func toast(message: String) {
        self.view.makeToast(message, duration: 1.5, position: ToastPosition.center)
    }
}
