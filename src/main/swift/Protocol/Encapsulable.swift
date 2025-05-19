//
//  NestedEnumerable.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import Foundation

public protocol Encapsulable: Enumerable {
    var enumeror: Enumeror { get }
}

extension Encapsulable {
    
    public var id: String {
        self.enumeror.id
    }

    public var rawValue: String {
        self.enumeror.rawValue
    }
    
}
