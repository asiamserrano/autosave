//
//  Modes.swift
//  autosave
//
//  Created by Asia Serrano on 8/15/25.
//

import Foundation

public struct Modes: SortedSetProtocol {
    
    public typealias Element = ModeEnum
    public typealias List = [Element]
    public typealias Index = List.Index
    
    public private(set) var set: Group
    public private(set) var list: List
    public private(set) var builders: TagBuilders
    
    public init(_ s: Group, _ l: List) {
        self.set = s
        self.list = l
        self.builders = s.builders
    }
    
}

extension Modes {
    
    public static func -->(lhs: inout Self, rhs: Group) -> Void {
        lhs.set = rhs
        lhs.list = rhs.sorted()
        lhs.builders = rhs.builders
    }
    
}

fileprivate extension Set where Element == ModeEnum {
    
    var builders: TagBuilders {
        .init(self.map { .mode ($0) })
    }
    
}
