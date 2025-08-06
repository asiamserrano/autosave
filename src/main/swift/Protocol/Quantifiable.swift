//
//  Quantifiable.swift
//  autosave
//
//  Created by Asia Serrano on 8/5/25.
//

import Foundation

public protocol Quantifiable {
    var count: Int { get }
}

public extension Quantifiable {
    
    var isEmpty: Bool {
        self.count == 0
    }
    
    var isNotEmpty: Bool {
        self.count > 0
    }
    
}
