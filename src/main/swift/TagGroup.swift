//
//  TagGroup.swift
//  autosave
//
//  Created by Asia Serrano on 8/14/25.
//

import Foundation

public struct Tags {
    
    public private(set) var inputsMap: InputsMap = .defaultValue
    public private(set) var platformsMap: PlatformsMap = .defaultValue
    public private(set) var modes: ModeEnums = .defaultValue
    
    public init() {}
}

public extension Tags {
    
    typealias Index = PlatformsMap.Index
    
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
    
    static func -= (lhs: inout Self, rhs: Index) -> Void {
        lhs --> (lhs.platformsMap - rhs)
    }
    
    static func -= (lhs: inout Self, rhs: SystemBuilder) -> Void {
        lhs --> (lhs.platformsMap - rhs)
    }

    static func += (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputsMap + i)
        case .mode(let m):
            lhs --> (lhs.modes + m)
        case .platform(let p):
            lhs --> (lhs.platformsMap + p)
        }
    }
    
    static func -= (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputsMap - i)
        case .mode(let m):
            lhs --> (lhs.modes - m)
        case .platform(let p):
            lhs --> (lhs.platformsMap - p)
        }
    }
    
    static func -= (lhs: inout Self, rhs: InputEnum) -> Void {
        lhs --> (lhs.inputsMap - rhs)
    }

    var inputs: InputEnums { self.inputsMap.keys }
    var systems: SystemEnums { self.platformsMap.keys }
    
    var builders: TagBuilders {
        self.inputsMap.builders + self.modes.builders + self.platformsMap.builders
    }

    subscript(key: InputEnum) -> StringBuilders {
        get {
            self.inputsMap[key]
        }
    }
    
    subscript(key: SystemBuilder) -> FormatsMap {
        get {
            self[key.type][key]
        }
    }
    
    subscript(key: Index) -> FormatBuilders {
        get {
            self[key.0][key.1]
        }
    }
    
    subscript(key: SystemEnum) -> SystemsMap {
        get {
            self.platformsMap[key]
        }
    }
    
}

private extension Tags {
    
    static func -->(lhs: inout Self, rhs: ModeEnums) -> Void {
        lhs.modes = rhs
    }
    
    static func -->(lhs: inout Self, rhs: InputsMap) -> Void {
        lhs.inputsMap = rhs
    }
    
    static func -->(lhs: inout Self, rhs: PlatformsMap) -> Void {
        lhs.platformsMap = rhs
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
