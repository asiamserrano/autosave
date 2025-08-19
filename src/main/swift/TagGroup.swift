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
    private var map: TagsBuilders = .init()
    
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
            let strings: StringBuilders = .random(RANDOM_RANGE)
            strings.forEach { value in
                let input: InputBuilder = .init(i, value.trim)
                new += (.input(input))
            }
        }
        
        ModeEnum.allCases.forEach { mode in
            bool = .random()
            if bool {
                new += (.mode(mode))
            }
        }
        
        let systems: SortedSet<SystemBuilder> = .random(RANDOM_RANGE)
        
        systems.forEach { system in
            system.formatBuilders.forEach { format in
                bool = .random()
                if bool {
                    let platform: PlatformBuilder = .init(system, format)
                    new += (.platform(platform))
                }
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
        let te: TagsEnum = .platform(sb)
        
        lhs.platformsMap --> (se, lhs[se] --> (lhs[sb] - (fb.type, fb), sb))
        lhs.map --> (te, lhs[te] - .platform(rhs))
    }
    
    static func -= (lhs: inout Self, rhs: PlatformElement) -> Void {
        let sb: SystemBuilder = rhs.0
        let fe: FormatEnum = rhs.1
        let se: SystemEnum = sb.type
        let te: TagsEnum = .platform(sb)
        let formats: Formats = lhs[sb]
        
        lhs.platformsMap --> (se, lhs[se] --> (formats - fe, sb))
        lhs.map --> (te, lhs[te] - formats.get(fe).toBuilders(sb))
    }
    
    static func -= (lhs: inout Self, rhs: SystemBuilder) -> Void {
        let key: SystemEnum = rhs.type
        
        lhs.platformsMap --> (key, lhs[key] - rhs)
        lhs.map -= .platform(rhs)
    }

    static func += (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            let key: InputEnum = i.type
            lhs[key] = lhs[key] + i.stringBuilder
        case .mode(let m):
            lhs --> (lhs.modes + m)
        case .platform(let p):
            let sb: SystemBuilder = p.system
            let fb: FormatBuilder = p.format
            let se: SystemEnum = sb.type
            let te: TagsEnum = .platform(sb)
            
            lhs.platformsMap --> (se, lhs[se] --> (lhs[sb] + (fb.type, fb), sb))
            lhs.map --> (te, lhs[te] + .platform(p))
        }
    }
    
    static func -= (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            let key: InputEnum = i.type
            lhs[key] = lhs[key] - i.stringBuilder
        case .mode(let m):
            lhs --> (lhs.modes - m)
        case .platform(let p):
            lhs -= p
        }
    }

    var inputs: InputEnums { .init(self.inputsMap.keys) }
    var systems: SystemEnums { .init(self.platformsMap.keys) }
    var builders: TagBuilders { .init(self.map.flatMap(\.value)) }
        
    func get(_ key: SystemEnum) -> SystemBuilders { .init(self[key].keys) }
    func get(_ key: SystemBuilder) -> FormatEnums { .init(self[key].keys) }
    func get(_ key: InputEnum) -> StringBuilders { self[key] }
    func get(_ system: SystemBuilder, _ format: FormatEnum) -> FormatBuilders { self[(system, format)] }

}

private extension Tags {
    
    typealias TagsBuilders = [TagsEnum: TagBuilders]
    
    enum TagsEnum: Hashable {
        case input(InputEnum)
        case mode
        case platform(SystemBuilder)
    }
    
    static var RANDOM_RANGE: Range<Int> = 0..<3
    
    static func -->(lhs: inout Self, rhs: ModeEnums) -> Void {
        lhs.modes = rhs
        lhs.map --> (.mode, rhs.toBuilders)
    }

    subscript(key: InputEnum) -> StringBuilders {
        get {
            self.inputsMap.get(key)
        } set {
            self.inputsMap --> (key, newValue)
            self.map --> (.input(key), newValue.toBuilders(key))
        }
    }
    
    subscript(key: SystemEnum) -> Systems {
        get {
            self.platformsMap.get(key)
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
    
    subscript(key: TagsEnum) -> TagBuilders {
        get {
            self.map.get(key)
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
