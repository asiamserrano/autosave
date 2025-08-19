//
//  TagGroup.swift
//  autosave
//
//  Created by Asia Serrano on 8/14/25.
//

import Foundation

public protocol TagsQueryKey { associatedtype Output }

//public typealias StringBuilderMap = CustomDictionary

public struct InputsKey: TagsQueryKey {
    public typealias Output = StringBuilders
    public let input: InputEnum
    public init(_ input: InputEnum) { self.input = input }
}

public struct ModesKey: TagsQueryKey {
    public typealias Output = Modes
    public init() {}
}

public struct PlatformKey: TagsQueryKey {
    public typealias Output = SortedSet<SystemBuilder>
    public let system: SystemEnum
    public init(_ system: SystemEnum) { self.system = system }
}

// (Optional) convenience keys for intermediate queries:
public struct SystemsKey: TagsQueryKey {
    public typealias Output = SortedSet<FormatEnum>
    public let builder: SystemBuilder
    
    public init(_ builder: SystemBuilder) {
        self.builder = builder
    }
}

public struct FormatsKey: TagsQueryKey {
    public typealias Output = FormatBuilders
    public let builder: SystemBuilder
    public let format: FormatEnum
    
    public init(_ builder: SystemBuilder, _ format: FormatEnum) {
        self.builder = builder
        self.format = format
    }
    
}


//public typealias Inputs = [InputEnum: StringBuilders]
public typealias Modes = SortedSet<ModeEnum>
public typealias Inputs = SortedSet<InputEnum>
public typealias Formats = [FormatEnum: FormatBuilders]
public typealias Systems = [SystemBuilder: Formats]
public typealias Platforms = [SystemEnum: Systems]

public struct Tags {
    
    private var inputsMap: [InputEnum: StringBuilders] = .defaultValue
    private var platformsMap: [SystemEnum: [SystemBuilder: [FormatEnum: FormatBuilders]]] = .defaultValue
    private var map: TagsBuilders = .init()
    
    public private(set) var modes: Modes = .defaultValue
    
    public init() {}
}

public extension Tags {
    
    // remove a format builder
    // remove a format enum
    // remove a system builder
    
    typealias PlatformElement = (SystemBuilder, FormatEnum)
    
    static func -= (lhs: inout Self, rhs: PlatformBuilder) -> Void {
        let sb: SystemBuilder = rhs.system
        let fb: FormatBuilder = rhs.format
        let se: SystemEnum = sb.type
        let te: TagsEnum = .platform(sb)
        
        lhs.platformsMap --> (se, lhs[se] --> (lhs[sb] - (fb.type, fb), sb))
        lhs.map --> (te, lhs[te] - .platform(rhs))
    }
    
    static func -= (lhs: inout Self, rhs: PlatformElement) -> Void {
        let systemBuilder: SystemBuilder = rhs.0
        let formatEnum: FormatEnum = rhs.1
        let systemEnum: SystemEnum = systemBuilder.type
        let tagsEnum: TagsEnum = .platform(systemBuilder)
        
        var formats: Formats = lhs[systemBuilder]
        
        let formatBuilders: FormatBuilders = formats[formatEnum] ?? .defaultValue
        
        formats[formatEnum] = nil
        
        var systems: Systems = lhs[systemEnum]
        systems[systemBuilder] = formats.isEmpty ? nil : formats
        
        lhs.platformsMap[systemEnum] = systems.isEmpty ? nil : systems
        lhs.map[tagsEnum] = (lhs.map[tagsEnum] ?? .defaultValue) - .init(formatBuilders.map { .platform(.init(systemBuilder, $0)) })
        
    }
    
    static func -= (lhs: inout Self, rhs: SystemBuilder) -> Void {
        var systems: Systems = lhs[rhs.type]
        systems[rhs] = nil
        lhs.platformsMap[rhs.type] = systems
        lhs.map[.platform(rhs)] = nil
    }

    static func += (lhs: inout Self, rhs: TagBuilder) -> Void {
        switch rhs {
        case .input(let i):
            let key: InputEnum = i.type
            lhs[key] = lhs[key] + i.stringBuilder
        case .mode(let m):
            lhs --> (lhs.modes + m)
        case .platform(let p):
            let systemBuilder: SystemBuilder = p.system
            let formatBuilder: FormatBuilder = p.format
            let formatEnum: FormatEnum = formatBuilder.type
            let systemEnum: SystemEnum = systemBuilder.type
            let tagsEnum: TagsEnum = .platform(systemBuilder)
            
            var formats: Formats = lhs[systemBuilder]
            
            let formatBuilders: FormatBuilders = formats[formatEnum] ?? .defaultValue
            
            formats[formatEnum] = formatBuilders + formatBuilder
            
            var systems: Systems = lhs[systemEnum]
            systems[systemBuilder] = formats.isEmpty ? nil : formats
            
            lhs.platformsMap[systemEnum] = systems.isEmpty ? nil : systems
            lhs.map[tagsEnum] = (lhs.map[tagsEnum] ?? .defaultValue) + .platform(p)
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

    var inputs: Inputs { .init(self.inputsMap.keys) }
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
    
    static func -->(lhs: inout Self, rhs: Modes) -> Void {
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

//fileprivate extension Formats {
//    
//    static func -= (lhs: inout Self, rhs: Key) -> Void {
//        lhs[rhs] = nil
//    }
//    
//    static func -= (lhs: inout Self, rhs: Value.Element) -> Void {
//        let key: Key = rhs.type
//        let value: Value = lhs.get(key) - rhs
//        lhs[key] = value.isEmpty ? nil : value
//    }
//    
//}
