//
//  TagGroup.swift
//  autosave
//
//  Created by Asia Serrano on 8/14/25.
//

import Foundation

public struct Tags {
    
    public private(set) var inputs: InputsMap = .defaultValue
    public private(set) var platforms: PlatformsMap = .defaultValue
    public private(set) var modes: ModeEnums = .defaultValue
    
    public init() {}
}

public extension Tags {
    
    typealias PlatformsIndex = PlatformsMap.Index
    
    static func random(_ status: GameStatusEnum) -> Self {
        switch status {
        case .library:
            return .random
        case .wishlist:
            return .defaultValue
        }
    }
    
    static var random: Self {
        
        let RANDOM_RANGE: Range<Int> = 0..<3
        var new: Self = .init()
        var bool: Bool = false
        
        InputEnum.cases.forEach { i in
            for _ in RANDOM_RANGE {
                new += .input(i, .random)
            }
        }
        
        ModeEnum.allCases.forEach { mode in
            bool = .random()
            if bool { new += .mode(mode) }
        }
        
        let systems: SortedSet<SystemBuilder> = .random(RANDOM_RANGE)
        
        systems.forEach { system in
            system.formatBuilders.forEach { format in
                bool = .random()
                if bool { new += .platform(system, format) }
            }
        }
        
        return new
    }
    
    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
        var new: Self = .init()
        relations.forEach { relation in
            if let builder: TagBuilder = relation.getTagBuilder(properties) {
                new += builder
            }
        }
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
    
    static func -= (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputs - i)
        case .mode(let m):
            lhs --> (lhs.modes - m)
        case .platform(let p):
            lhs --> (lhs.platforms - p)
        }
    }

    static func += (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputs + i)
        case .mode(let m):
            lhs --> (lhs.modes + m)
        case .platform(let p):
            lhs --> (lhs.platforms + p)
        }
    }
    
//    var inputs: InputEnums { self.inputs.keys }
//    var systems: SystemEnums { self.platforms.keys }
    
    var builders: TagBuilders {
        self.inputs.builders + self.modes.builders + self.platforms.builders
    }

    subscript(key: InputEnum) -> StringBuilders {
        get {
            self.inputs[key]
        }
    }
    
    subscript(key: SystemBuilder) -> FormatsMap {
        get {
            self[key.type][key]
        }
    }
    
    subscript(key: PlatformsIndex) -> FormatBuilders {
        get {
            self[key.0][key.1]
        }
    }
    
    subscript(key: SystemEnum) -> SystemsMap {
        get {
            self.platforms[key]
        }
    }
    
}

private extension Tags {
    
    static func -->(lhs: inout Self, rhs: ModeEnums) -> Void {
        lhs.modes = rhs
    }
    
    static func -->(lhs: inout Self, rhs: InputsMap) -> Void {
        lhs.inputs = rhs
    }
    
    static func -->(lhs: inout Self, rhs: PlatformsMap) -> Void {
        lhs.platforms = rhs
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
