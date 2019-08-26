//
//  Queue.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-08-26.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation


public struct Queue<T> {
    private var array: [T]
    
    public init() {
        array = []
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public func peek() -> T? {
        return array.first
    }
}
