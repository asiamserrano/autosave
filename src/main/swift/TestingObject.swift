//
//  TestingObject.swift
//  autosave
//
//  Created by Asia Serrano on 8/4/25.
//

import Foundation

public struct TagContainer {
    
    public var builders: Builders = .defaultValue
    
    private var inputs: Inputs = .defaultValue
    private var modes: Modes = .defaultValue
    private var platforms: Platforms = .defaultValue
    
}

private extension TagContainer {
    
    static var RANDOM_RANGE: Range<Int> = 0..<3
    
//    private init(_ other: Self) {
//        self.builders = other.builders
//        self.inputs = other.inputs
//        self.modes = other.modes
//        self.platforms = other.platforms
//    }
    
}

public extension TagContainer {
    
    typealias Builder = TagBuilder
    typealias Builders = SortedSet<Builder>
    
    static func ==(lhs: Self, rhs: Builders) -> Bool {
        lhs.builders == rhs
    }
    
    static func +=(lhs: inout Self, rhs: Builder?) -> Void {
        if let builder: Builder = rhs {
            switch builder {
            case .input(let input):
                lhs.inputs += input
            case .mode(let mode):
                lhs.modes += mode
            case .platform(let platform):
                lhs.platforms += platform
            }
            
            lhs.builders += builder
        }
    }
    
    static func -=(lhs: inout Self, rhs: Builder?) -> Void {
        if let builder: Builder = rhs {
            switch builder {
            case .input(let input):
                lhs.inputs -= input
            case .mode(let mode):
                lhs.modes -= mode
            case .platform(let platform):
                print(platform)
                lhs.platforms -= platform
            }
            
            lhs.builders -= builder
        }
    }
    
    static func build(_ relations: [RelationModel], _ properties: [PropertyModel]) -> Self {
        var new: Self = .init()
        relations.forEach {
            if let builder: Builder = $0.getTagBuilder(properties) {
                new += builder
            }
        }
        return new
    }
    
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
        
        Inputs.Key.cases.forEach { i in
            let strings: Inputs.Value = .random(RANDOM_RANGE)
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
    
    func get(_ category: TagCategory) -> TagsElement {
        switch category {
        case .input:
            return .inputs(self.inputs)
        case .mode:
            return .modes(self.modes)
        case .platform:
            return .platforms(self.platforms)
        }
    }
    
    func get(_ tagType: TagType) -> TagsElement {
        self.get(tagType.category)
    }
    
    func get(_ system: SystemBuilder?) -> Formats {
        if let system: SystemBuilder = system {
            return self.platforms.get(system)
        } else {
            return .defaultValue
        }
    }
    
    func contains(_ builder: Builder) -> Bool {
        self.builders.contains(builder)
    }
    
    var systems: [Systems.Key] {
        self.platforms.values.flatMap { $0.keys }
    }
    
}


extension TagContainer: Stable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.builders)
    }
    
}

extension TagContainer: Defaultable {
    
    public static var defaultValue: Self { .init() }
    
}

extension TagContainer: Quantifiable {
    
    public var count: Int { self.builders.count }
    
}

public enum TagsElement: Quantifiable {
    case inputs(Inputs)
    case modes(Modes)
    case platforms(Platforms)

//    public var isEmpty: Bool {
//        switch self {
//        case .inputs(let inputs):
//            return inputs.isEmpty
//        case .modes(let modes):
//            return modes.isEmpty
//        case .platforms(let platforms):
//            return platforms.isEmpty
//        }
//    }
    
    public var count: Int {
        switch self {
        case .inputs(let inputs):
            return inputs.count
        case .modes(let modes):
            return modes.count
        case .platforms(let platforms):
            return platforms.count
        }
    }

}

