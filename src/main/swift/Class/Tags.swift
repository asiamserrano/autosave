//
//  Tags.swift
//  autosave
//
//  Created by Asia Serrano on 6/24/25.
//

import Foundation

// TODO: Fix this
public struct Tags {
    
    public static var defaultValue: Self {
        .init()
    }
    
    public static var random: Self {
//        return .defaultValue
        return .init(.random, .random, .random)
    }
    
    public static func build(_ tags: [Builder]) -> Self {
        var map: Self = .init()
        tags.forEach { map.add($0) }
        return map
    }
    
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
    
    private var inputs: Inputs
    private var modes: Modes
    private var platforms: Platforms
    
    private init() {
        self.inputs = .init()
        self.modes = .init()
        self.platforms = .init()
    }
    
    private init(_ inputs: Inputs, _ modes: Modes, _ platforms: Platforms) {
        self.inputs = inputs
        self.modes = modes
        self.platforms = platforms
    }
    
    public func contains(_ builder: Builder) -> Bool {
        let category: Category = builder.type.category
        let element: Element = self.get(category)
        return element.builders.contains(builder)
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
    }
            
    public func category(_ category: Category) -> Element? {
        let element: Element = self.get(category)
        return element.isEmpty ? nil : element
    }
    
    public var isEmpty: Bool {
        self.inputs.isEmpty
        && self.modes.isEmpty
        && self.platforms.isEmpty
    }
    
    public var builders: [Builder] {
        var result: [Builder] = .init()
        Category.cases.forEach {
            let element: Element = self.get($0)
            result.append(contentsOf: element.builders)
        }
        return result
    }
    
}

extension Tags: Hashable {
    
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
        
        public var builders: [Builder] {
            switch self {
            case .inputs(let inputs):
                var result: [Builder] = .init()
                inputs.forEach { key, values in
                    let tags: [Builder] = values.tags(key)
                    result.append(contentsOf: tags)
                }
                return result
            case .modes(let modes):
                return modes.modeEnums.map(TagBuilder.mode)
            case .platforms(let platforms):
                var result: [Builder] = .init()
                platforms.forEach { key, values in
                    let tags: [Builder] = values.tags(key)
                    result.append(contentsOf: tags)
                }
                return result
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
