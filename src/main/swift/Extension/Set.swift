//
//  Set.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import Foundation

extension Set: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
    public init(_ element: Element) {
        self = [element]
    }
    
    mutating func delete(_ element: Element) -> Void {
        self = self.filter(element)
    }
    
    func filter(_ element: Element) -> Self {
        self.filter { $0 != element }
    }
    
}

extension Set where Element == StringBuilder {
    
    public static func random(_ range: Range<Int>) -> Self {
        let size: Int = Int.random(in: range)
        
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
    
    public func remove(_ format: FormatEnum) -> Self {
        self.filter { $0.type != format }
    }
    
    public func remove(_ format: FormatBuilder) -> Self {
        self.filter { $0 != format }
    }
    
}

extension Set where Element == SystemBuilder {
    
    public static func random(_ range: Range<Int>) -> Self {
        
        let size: Int = Int.random(in: range)
        
        var set: Self = .init()
        
        while set.count < size {
            set.insert(.random)
        }
        
        return set
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
