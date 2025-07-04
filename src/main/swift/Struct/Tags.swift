//
//  Tags.swift
//  autosave
//
//  Created by Asia Serrano on 6/24/25.
//

import Foundation

// TODO: Fix this
public struct Tags {
    
    public static var random: Self {
        var map: Self = .init()
        
        var bool: Bool = false
        
        let range: Range<Int> = 0..<3
        
        Inputs.Key.cases.forEach { i in
            let strings: Inputs.Value = .random(range)
            strings.forEach { value in
                let input: InputBuilder = .init(i, value.trim)
                map.add(.input(input))
            }
        }
        
        Modes.Key.cases.forEach { mode in
            bool = .random()
            if bool {
                map.add(.mode(mode))
            }
        }
        
        let systems: Set<Platforms.Key> = .random(range)
        
        systems.forEach { system in
            system.formatBuilders.forEach { format in
                bool = .random()
                if bool {
                    let platform: PlatformBuilder = .init(system, format)
                    map.add(.platform(platform))
                }
            }
        }
        
        return map
    }
    
    public static func random(_ status: GameStatusEnum) -> Self {
        switch status {
        case .library:
            return .random
        case .wishlist:
            return .defaultValue
        }
    }
    
//    public static func build(_ tags: [Builder]) -> Self {
//        var map: Self = .init()
//        tags.forEach { map.add($0) }
//        return map
//    }
    
    public static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
        var map: Self = .init()
        
        relations.forEach { relation in
            if let key: PropertyModel = properties.get(relation.key_uuid) {
                let property: PropertyBuilder = .fromModel(key)
                switch property {
                case .input(let i):
                    let builder: TagBuilder = .input(i)
                    map.add(builder)
                case .selected(let s):
                    switch s {
                    case .mode(let m):
                        let builder: TagBuilder = .mode(m)
                        map.add(builder)
                    default:
                        if let value: PropertyModel = properties.get(relation.value_uuid),
                           let platform: PlatformBuilder = .fromModels(key, value) {
                            let builder: TagBuilder = .platform(platform)
                            map.add(builder)
                        }
                    }
                }
            }
        }
        
        return map
    }
    
    public private(set) var inputs: Inputs
    public private(set) var modes: Modes
    public private(set) var platforms: Platforms
    
    public private(set) var builders: Set<Builder> = .init()
    
    private init() {
        self.inputs = .init()
        self.modes = .init()
        self.platforms = .init()
    }
    
    public func contains(_ builder: Builder) -> Bool {
        switch builder {
        case .input(let i):
            return self.inputs.getOrDefault(i.type).contains(i.stringBuilder)
        case .mode(let m):
            return self.modes.enums.contains(m)
        case .platform(let p):
            return self.platforms.getOrDefault(p.system).contains(p.format)
        }
    }
    
    public mutating func add(_ builder: Builder) -> Void {
        switch builder {
        case .input(let i):
            let key: Inputs.Key = i.type
            var set: Inputs.Value = inputs.getOrDefault(key)
            set.insert(i.stringBuilder)
            self.inputs[key] = set
        case .mode(let m):
            self.modes[m] = true
        case .platform(let p):
            let key: Platforms.Key = p.system
            var set: Platforms.Value = platforms.getOrDefault(key)
            set.insert(p.format)
            self.platforms[key] = set
        }
        
        self.builders.insert(builder)
    }
    
    public mutating func delete(_ builder: Builder) -> Void {
        switch builder {
        case .input(let i):
            let key: Inputs.Key = i.type
            self.inputs[key] = inputs.getOrDefault(key).delete(i.stringBuilder)
        case .mode(let m):
            self.modes[m] = false
        case .platform(let p):
            let key: Platforms.Key = p.system
            self.platforms[key] = platforms.getOrDefault(key).delete(p.format)
        }
        
        self.builders.remove(builder)
    }
            
    public func category(_ category: Category) -> Element? {
        let element: Element = self.get(category)
        return element.isEmpty ? nil : element
    }
    
//    public func builders(_ type: TagType) -> [Builder] {
//        let element: Element = self.get(type.category)
//        switch element {
//        case .inputs(let i):
//            let input: InputEnum = .init(type)
//            let value: Inputs.Value = i.getOrDefault(input)
//            return value.map { .input(.init(input, $0.trim)) }.sorted()
//        case .modes(let m):
//            return m.enums.map { .mode($0) }
//        case .platforms(let p):
//            return p.enums.flatMap { system in
//                p.getOrDefault(system).map { format in
//                        .platform(.init(system, format))
//                }
//            }
//        }
//    }
    
    public var isEmpty: Bool {
        self.inputs.isEmpty
        && self.modes.isEmpty
        && self.platforms.isEmpty
    }
    
}

extension Tags: Defaultable {
    
    public static var defaultValue: Self { .init() }
}

extension Tags: Stable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.builders)
    }
    
}

public extension Tags {
    
    typealias Builder = TagBuilder
    typealias Category = TagCategory
    
    typealias Inputs = [InputEnum: Set<StringBuilder>]
    typealias Modes = [ModeEnum: Bool]
    typealias Platforms = [SystemBuilder: Set<FormatBuilder>]
    
    enum Element {
        case inputs(Inputs)
        case modes(Modes)
        case platforms(Platforms)
        
        public var isEmpty: Bool {
            switch self {
            case .inputs(let inputs):
                return inputs.isEmpty
            case .modes(let modes):
                return modes.isEmpty
            case .platforms(let platforms):
                return platforms.isEmpty
            }
        }
        
    }
}

private extension Tags {
    
    enum Values {
        case inputs(Inputs.Value)
        case modes(Modes.Keys)
        case platforms(Platforms.Value)
    }
    
    func get(_ category: Category) -> Element {
        switch category {
        case .input:
            return .inputs(inputs)
        case .mode:
            return .modes(modes)
        case .platform:
            return .platforms(platforms)
        }
    }
    
}
