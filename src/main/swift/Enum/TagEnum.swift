//
//  TagEnum.swift
//  autosave
//
//  Created by Asia Serrano on 6/19/25.
//

import Foundation

public enum TagEnum: Enumerable {
    case input, mode, platform
}

public enum TagBuilder {
    
    public static var random: Self {
        let tag: TagEnum = .random
        switch tag {
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
    
//    public var type: TagEnum {
//        switch self {
//        case .input:
//            return .input
//        case .mode:
//            return .mode
//        case .platform:
//            return .platform
//        }
//    }
    
}

public struct TagSnapshot {
    
//    public static func fromBuilder(_ builder: TagBuilder) -> Self {
//        let key: PropertySnapshot = builder.key
//        let value: PropertySnapshot = builder.value
//        return .init(key, value)
//    }
        
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
    
}
