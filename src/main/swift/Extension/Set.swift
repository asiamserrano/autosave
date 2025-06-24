//
//  Set.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation

extension Set {
    
    public init(_ element: Element) {
        self = [element]
    }
    
    func delete(_ element: Element) -> Self {
        self.filter { $0 != element }
    }
    
}

extension Set where Element == StringBuilder {
    
    public func inputs(_ input: InputEnum) -> [InputBuilder] {
        self.map { .init(input, $0.trim) }
    }
    
}

extension Set where Element == FormatBuilder {
    
    public func platforms(_ system: SystemBuilder) -> [PlatformBuilder] {
        self.map { .init(system, $0) }
    }
    
}
