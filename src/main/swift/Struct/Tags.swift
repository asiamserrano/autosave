//
//  Tags.swift
//  autosave
//
//  Created by Asia Serrano on 6/24/25.
//

import Foundation

public struct Tags: TagsProtocol {
    
    public private(set) var inputs: Inputs = .defaultValue
    public private(set) var platforms: Platforms = .defaultValue
    public private(set) var modes: Modes = .defaultValue
    
    public init() {}
}

public extension Tags {
    
    typealias Element = TagBuilder
    typealias PlatformsIndex = Platforms.Index
    
    static func random(_ status: GameStatusEnum) -> Self {
        switch status {
        case .library:
            return .random
        case .wishlist:
            return .defaultValue
        }
    }
    
    static var random: Self {
        var new: Self = .init()
        
        InputEnum.cases.forEach { i in StringBuilders.random.forEach { new += .input(i, $0) } }
        ModeEnum.allCases.forEach { if Bool.random() { new += .mode($0) } }
        SystemBuilders.random.forEach { s in s.formatBuilders.forEach { if Bool.random() { new += .platform(s, $0) } } }
        return new
    }
    
    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
        var new: Self = .init()
        relations.forEach { new += ($0, properties) }
        return new
    }
    
    static func -= (lhs: inout Self, rhs: PlatformsIndex) -> Void {
        lhs --> (lhs.platforms - rhs)
    }
    
    static func -= (lhs: inout Self, rhs: SystemBuilder) -> Void {
        lhs --> (lhs.platforms - rhs)
    }
    
    static func -= (lhs: inout Self, rhs: InputEnum) -> Void {
        lhs --> (lhs.inputs - rhs)
    }
    
    static func -= (lhs: inout Self, rhs: Element) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputs - i)
        case .mode(let m):
            lhs --> (lhs.modes - m)
        case .platform(let p):
            lhs --> (lhs.platforms - p)
        }
    }

    static func += (lhs: inout Self, rhs: Element) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputs + i)
        case .mode(let m):
            lhs --> (lhs.modes + m)
        case .platform(let p):
            lhs --> (lhs.platforms + p)
        }
    }

    var builders: TagBuilders {
        self.inputs.builders + self.modes.builders + self.platforms.builders
    }

    subscript(key: InputEnum) -> StringBuilders {
        get {
            self.inputs[key]
        }
    }
    
    subscript(key: InputEnum) -> TagBuilders {
        get {
            self.inputs[key]
        }
    }
    
    subscript(key: SystemBuilder) -> Formats {
        get {
            self[key.type][key]
        }
    }
    
    subscript(key: SystemBuilder) -> TagBuilders {
        get {
            self[key].builders
        }
    }
    
    subscript(key: PlatformsIndex) -> FormatBuilders {
        get {
            self[key.0][key.1]
        }
    }
    
    subscript(key: PlatformsIndex) -> TagBuilders {
        get {
            self[key.0][key.1]
        }
    }
    
    subscript(key: SystemEnum) -> Systems {
        get {
            self.platforms[key]
        }
    }
    
}

private extension Tags {
    
    static func -->(lhs: inout Self, rhs: Modes) -> Void {
        lhs.modes = rhs
    }
    
    static func -->(lhs: inout Self, rhs: Inputs) -> Void {
        lhs.inputs = rhs
    }
    
    static func -->(lhs: inout Self, rhs: Platforms) -> Void {
        lhs.platforms = rhs
    }
    
    static func +=(lhs: inout Self, rhs: (RelationModel, [PropertyModel])) -> Void {
        if let builder: Element = rhs.0.getTagBuilder(rhs.1) {
            lhs += builder
        }
    }
    
}

extension Tags: Stable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.builders)
    }
    
}

extension Tags: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension Tags: Quantifiable {
    
    public var quantity: Int { self.builders.count }
    
}

//public extension Tags {
//    
//    enum Grouping {
//        case inputs(Inputs)
//        case modes(Modes)
//        case platforms(Platforms)
//    }
//    
//}
