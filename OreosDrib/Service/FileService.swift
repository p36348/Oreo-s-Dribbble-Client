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
    
    static var library: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    
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
    
    func creat(data: Data, path: String, fileName: String, completion: @escaping (Error?) -> Void) {
        self.operationQueue.addOperation {
            DispatchQueue.global().async {
                let _fileManager: FileManager = FileManager.default
                
                if !_fileManager.fileExists(atPath: path) {
                    do {
                        try _fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    }catch {
                        return completion(error)
                    }
                }
                
                var _error: Error?
                
                if !_fileManager.createFile(atPath: path + "/" + fileName, contents: data, attributes: nil) {
                    _error = NSError(domain: "Faild to creat file at path:" + path, code: 0, userInfo: nil)
                }
                
                DispatchQueue.main.sync {
                    completion(_error)
                }
            }
        }
    }
    
    func creat(image: UIImage, fileName: String, completion: @escaping (Error?) -> Void) {
        guard let _data = UIImagePNGRepresentation(image) else {
            return completion(NSError(domain: "Faild to convert" + image.description + "to data", code: 0 , userInfo: nil))
        }
        self.creat(data: _data, path: SanBoxPath.images, fileName: fileName, completion: completion)
    }
    
    func creat(json: JSON, fileName: String, completion: @escaping (Error?) -> Void) {
        var _data: Data?
        do {
            _data = try json.rawData()
        }catch {
            return completion(error)
        }
        
        self.creat(data: _data!, path: SanBoxPath.caches + "/shots", fileName: fileName, completion: completion)
    }
    
    func searchCache(fileName: String, completion: @escaping (Data?, Error?) -> Void) {
        let _fileManager = FileManager.default
        self.operationQueue.addOperation {
            DispatchQueue.global().async {
                let data = _fileManager.contents(atPath: SanBoxPath.caches + "/shots/" + fileName)
                
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
            
        }
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
