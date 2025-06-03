//
//  Int.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public extension Int {
    
    static var one: Self { 1 }
    
    var leadingZero: String {
        return String(format: "%02d", self)
    }
    
}
