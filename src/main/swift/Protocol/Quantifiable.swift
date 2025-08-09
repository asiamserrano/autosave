//
//  Quantifiable.swift
//  autosave
//
//  Created by Asia Serrano on 8/5/25.
//

import Foundation

public protocol Quantifiable {
    var quantity: Int { get }
}

public extension Quantifiable {
    
    var isVacant: Bool {
        self.quantity == 0
    }
    
    var isOccupied: Bool {
        self.quantity > 0
    }
    
}
