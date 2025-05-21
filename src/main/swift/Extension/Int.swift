//
//  Int.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public extension Int {
    
    var leadingZero: String {
        return String(format: "%02d", self)
    }
    
    var isGreaterThanZero: Bool {
        self > 0
    }
    
}
