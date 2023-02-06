//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation

extension OperationQueue {
    static var serial: OperationQueue {
        let queue = OperationQueue()
        queue.name = "com.cluster.serialQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }
    
    func addBlockOperation(_ block: @escaping (BlockOperation) -> Void) {
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak operation] in
            guard let operation = operation else { return }
            block(operation)
        }
        self.addOperation(operation)
    }
}
