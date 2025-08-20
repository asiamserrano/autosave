//
//  TagEnum.swift
//  autosave
//
//  Created by Asia Serrano on 6/19/25.
//

import Foundation

public enum TagCategory: Enumerable {
    case input, mode, platform
}

public enum TagType: Encapsulable {
    
    public static var allCases: Cases {
        TagCategory.allCases.flatMap { type in
            switch type {
            case .input:
                return InputEnum.cases.map(Self.input)
            case .mode:
                return Cases.init(.mode)
            case .platform:
                return Cases.init(.platform)
            }
        }
    }
    
    case input(InputEnum)
    case mode
    case platform
    
    public var enumeror: Enumeror {
        switch self {
        case .input(let i):
            return i
        case .mode:
            return TagCategory.mode
        case .platform:
            return TagCategory.platform
        }
    }
    
    public var category: TagCategory {
        switch self {
        case .input:
            return .input
        case .mode:
            return .mode
        case .platform:
            return .platform
        }
    }
    
}

public enum TagBuilder: Tagable {
    
    public static func input(_ i: InputEnum, _ s: StringBuilder) -> Self {
        let builder: InputBuilder = .init(i, s)
        return .input(builder)
    }
    
    public static func input(_ i: InputEnum, _ s: String) -> Self {
        let builder: InputBuilder = .init(i, s)
        return .input(builder)
    }
    
    public static func platform(_ system: SystemBuilder, _ format: FormatBuilder) -> Self {
        let builder: PlatformBuilder = .init(system, format)
        return .platform(system, format)
    }
    
    public static var random: Self {
        let category: TagCategory = .random
        switch category {
        case .input:
            return .input(.random)
        case .mode:
            return .mode(.random)
        case .platform:
            return .platform(.random)
        }
    }
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case platform(PlatformBuilder)
    
    public var key: PropertySnapshot {
        switch self {
        case .input(let i):
            let builder: PropertyBuilder = .input(i)
            return .fromBuilder(builder)
        case .mode(let m):
            let selected: SelectedBuilder = .mode(m)
            let property: PropertyBuilder = .selected(selected)
            return .fromBuilder(property)
        case .platform(let p):
            let system: SystemBuilder = p.system
            let selected: SelectedBuilder = .system(system)
            let property: PropertyBuilder = .selected(selected)
            return .fromBuilder(property)
        }
    }
    
    public var value: PropertySnapshot {
        switch self {
        case .platform(let p):
            let format: FormatBuilder = p.format
            let selected: SelectedBuilder = .format(format)
            let property: PropertyBuilder = .selected(selected)
            return .fromBuilder(property)
        default:
            return self.key
        }
    }
    
    public var type: TagType {
        switch self {
        case .input(let i):
            return .input(i.type)
        case .mode:
            return .mode
        case .platform:
            return .platform
        }
    }
    
}

public struct TagSnapshot: Tagable {

    public static func fromModel(_ key: PropertyModel, _ value: PropertyModel? = nil) -> Self {
        let key: PropertySnapshot = key.snapshot
        let value: PropertySnapshot = value?.snapshot ?? key
        return .init(key, value)
    }
    
    public let key: PropertySnapshot
    public let value: PropertySnapshot
    
    private init(_ key: PropertySnapshot, _ value: PropertySnapshot) {
        self.key = key
        self.value = value
    }
    
    public func getLabel(_ category: RelationCategory) -> RelationType {
        switch category {
        case .property:
            let type: PropertyType = self.key.builder.type
            return .property(type)
        case .tag:
            let tag: TagType = self.key.builder.tag
            return .tag(tag)
        }
    }
    
}
