//
//  TagGroup.swift
//  autosave
//
//  Created by Asia Serrano on 8/14/25.
//

import Foundation

public struct Tags {
    
    private var inputsMap: Inputs = .defaultValue
    private var platformsMap: Platforms = .defaultValue
//    private var map: TagsBuilders = .init()
    
    public private(set) var modes: ModeEnums = .defaultValue
    
    public init() {}
}

public extension Tags {
    
    typealias PlatformElement = (SystemBuilder, FormatEnum)
    
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
    
    static func -= (lhs: inout Self, rhs: PlatformBuilder) -> Void {
        let sb: SystemBuilder = rhs.system
        let fb: FormatBuilder = rhs.format
        let se: SystemEnum = sb.type

        lhs --> (lhs.platformsMap --> (lhs[se] --> (lhs[sb] - (fb.type, fb), sb), se))
    }
    
    static func -= (lhs: inout Self, rhs: PlatformElement) -> Void {
        let sb: SystemBuilder = rhs.0
        let fe: FormatEnum = rhs.1
        let se: SystemEnum = sb.type
        let formats: Formats = lhs[sb]

        lhs --> (lhs.platformsMap --> (lhs[se] --> (formats - fe, sb), se))
    }
    
    static func -= (lhs: inout Self, rhs: SystemBuilder) -> Void {
        let key: SystemEnum = rhs.type
        
        lhs --> (lhs.platformsMap --> (lhs[key] - rhs, key))
    }

    static func += (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputsMap + (i.type, i.stringBuilder))
        case .mode(let m):
            lhs --> (lhs.modes + m)
        case .platform(let p):
            let sb: SystemBuilder = p.system
            let fb: FormatBuilder = p.format
            let se: SystemEnum = sb.type
            
            lhs --> (lhs.platformsMap --> (lhs[se] --> (lhs[sb] + (fb.type, fb), sb), se))
        }
    }
    
    static func -= (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            lhs --> (lhs.inputsMap - (i.type, i.stringBuilder))
        case .mode(let m):
            lhs --> (lhs.modes - m)
        case .platform(let p):
            lhs -= p
        }
    }
    
    static func -= (lhs: inout Self, rhs: InputEnum) -> Void {
        lhs --> (lhs.inputsMap - rhs)
    }

    var inputs: InputEnums { .init(self.inputsMap.keys) }
    var systems: SystemEnums { .init(self.platformsMap.keys) }
    
    // TODO: Fix this
    var builders: TagBuilders {
        self.inputsMap.builders + self.modes.builders +
            .init(self.platformsMap.values.flatMap { $0.values.flatMap { $0.builders } })
    }
        
    func get(_ key: SystemEnum) -> SystemBuilders { .init(self[key].keys) }
    func get(_ key: SystemBuilder) -> FormatEnums { .init(self[key].keys) }
    func get(_ key: InputEnum) -> StringBuilders { self[key] }
    func get(_ system: SystemBuilder, _ format: FormatEnum) -> FormatBuilders { self[(system, format)] }

    subscript(key: InputEnum) -> StringBuilders {
        get {
            self.inputsMap.get(key)
        }
    }
    
    subscript(key: SystemBuilder) -> Formats {
        get {
            self[key.type].get(key)
        }
    }
    
    subscript(key: PlatformElement) -> FormatBuilders {
        get {
            self[key.0].get(key.1)
        }
    }

}

private extension Tags {

    static var RANDOM_RANGE: Range<Int> = 0..<3
    
    static func -->(lhs: inout Self, rhs: ModeEnums) -> Void {
        lhs.modes = rhs
    }
    
    static func -->(lhs: inout Self, rhs: Inputs) -> Void {
        lhs.inputsMap = rhs
    }
    
    static func -->(lhs: inout Self, rhs: Platforms) -> Void {
        lhs.platformsMap = rhs
    }
    
    subscript(key: SystemEnum) -> Systems {
        get {
            self.platformsMap.get(key)
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
