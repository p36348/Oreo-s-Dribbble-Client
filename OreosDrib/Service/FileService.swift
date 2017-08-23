//
//  FileService.swift
//  OreosDrib
//
//  Created by P36348 on 20/8/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

private struct SanBoxPath {
    static var home: String = NSHomeDirectory()
    
    static var documents: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    static var caches: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    static var temporary: String = NSTemporaryDirectory()
    
    static var images: String = documents.appending("/Images")
}

struct FileService {
    
    static let shared: FileService = FileService()
    
    private init() {}
    
    func write(image: UIImage, completion: () -> Void) {
        
    }
    
    func writeHomePage(json: JSON, completion: () -> Void) {
    
    }
    
}
