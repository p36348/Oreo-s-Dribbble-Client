//
//  UIViewController+Alert.swift
//  OreosDrib
//
//  Created by P36348 on 18/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

extension UIViewController {
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
        
        if navigationController?.topViewController == self || presentingViewController == nil{
            present(controller, animated: true, completion: nil)
        }
    }
}
