//
//  BlockOperation+Utils.swift
//  ThinkerBaseKit
//
//  Created by P36348 on 2018/4/24.
//  Copyright © 2018 P36348. All rights reserved.
//

import Foundation
import RxSwift

/// 创建一个轮询任务
///
/// - Parameters:
///   - gap: 轮询间隔
///   - loopBlock: 轮询行为
public func createLoopOperation(gap: TimeInterval, loopBlock: @escaping ()->Void) -> BlockOperation {
    let operation = BlockOperation()
    operation.addExecutionBlock { [weak operation] in
        while operation?.isCancelled == false {
            loopBlock()
            Thread.sleep(forTimeInterval: gap)
        }
    }
    return operation
}

public func rx_createLoopOperation(gap: TimeInterval, name: String, queue: OperationQueue? = nil) -> Observable<BlockOperation?> {
    let operation = BlockOperation()
    operation.name = name
    return Observable.create({ (observer) -> Disposable in
        
        operation.addExecutionBlock { [weak operation] in
            while operation?.isCancelled == false {
                observer.onNext(operation)
                Thread.sleep(forTimeInterval: gap)
            }
        }
        return Disposables.create()
    })
        .do(onSubscribed: {
            if
                let _queue = queue
            {
                _queue.addOperation(operation)
            }
            else
            {
                operation.start()
            }
        }, onDispose: { operation.cancel() })
}
