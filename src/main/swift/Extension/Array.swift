//
//  Array.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

public extension Array {
    
    static var defaultValue: Self { .init() }
    
    init(_ elements: Element...) {
        self = elements
    }
    
}

extension Array where Element == any PersistentModel.Type {
    
    public static var defaultValue: Self {
        [ GameModel.self ]
    }
    
}
