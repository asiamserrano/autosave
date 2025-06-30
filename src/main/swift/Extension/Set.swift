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
    
    public static func random(_ size: Int) -> Self {
        var set: Self = []
        while set.count < size {
            let element: Element = .string(.random)
            set.insert(element)
        }
        return set
    }
    
    public func tags(_ input: InputEnum) -> [TagBuilder] {
        self.map { InputBuilder(input, $0.trim) }.map(TagBuilder.input)
    }
    
}

extension Set where Element == FormatBuilder {
    
    public func tags(_ system: SystemBuilder) -> [TagBuilder] {
        self.map { PlatformBuilder(system, $0) }.map(TagBuilder.platform)
    }
    
}

//extension Set where Element == PlatformBuilder {
//    
//    public static func random(_ size: Int) -> Self {
//        var set: Self = []
//        while set.count < size {
//            set.insert(.random)
//        }
//        return set
//    }
//    
//}
