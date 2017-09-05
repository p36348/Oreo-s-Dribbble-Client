//
//  Captureable.swift
//  OreosDrib
//
//  Created by P36348 on 5/9/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
import SwViewCapture
import ReactiveSwift
import Result
public protocol Captureable {
    
}

typealias CaptureSignal = Signal<UIImage?, NoError>

extension UITableView: Captureable {
    
    func capture() -> CaptureSignal {
        
        let (signal, observer) = CaptureSignal.pipe()
        
        self.swContentCapture { (image) in
            observer.send(value: image)
            observer.sendCompleted()
        }
        return signal
        }
}
