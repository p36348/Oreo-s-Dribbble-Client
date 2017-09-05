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
import ReactiveSwift
import Result

struct SanBoxPath {
    
    static var home: String = NSHomeDirectory()
    
    static var documents: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    static var caches: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
    static var temporary: String = NSTemporaryDirectory()
    
    static var images: String = documents.appending("/Images")
}

struct FileService {
    
    static let shared: FileService = FileService()
    
    private let operationQueue: OperationQueue = {
        let _queue = OperationQueue()
        
        _queue.maxConcurrentOperationCount = 1
        _queue.qualityOfService = .utility
        
        return _queue
    }()
    
    public private(set) var (captureSignal, captureObserver) = Signal<String, NoError>.pipe()
    
    func creat(image: UIImage, completion: @escaping (Error?) -> Void) {
        
        operationQueue.addOperation {
            
            DispatchQueue.global().async {
                let _fileManager: FileManager = FileManager.default
                
                let path = SanBoxPath.images
                
                if !_fileManager.fileExists(atPath: path) {
                    do {
                        try _fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    }catch {
                        return completion(error)
                    }
                }
                
                let _data = UIImagePNGRepresentation(image)!
                
                var _error: Error?
                
                if !_fileManager.createFile(atPath: path, contents: _data, attributes: nil) {
                    _error = NSError(domain: "Faild to creat image at path:" + path, code: 0, userInfo: ["data": _data])
                }
                
                DispatchQueue.main.sync {
                    completion(_error)
                }
            }
        }
    }
    
    func creat(json: JSON, completion: () -> Void) {
    
    }
    
    private var isCalculating: Bool = false
    
    typealias Message = (message: String, error: Error?)
    
    func calculateSize(path: String, completion: @escaping (Message)->Void) {
        
        guard !isCalculating else {return completion(("Already processing", nil)) }
        
        operationQueue.addOperation {
            
            DispatchQueue.global().async {
                
                DispatchQueue.main.async {
                    completion(("Success", nil))
                }
            }
        }
    }
    
}
