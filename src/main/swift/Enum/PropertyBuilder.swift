//
//  PropertyBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

// TODO: change this to a 1:1 property builder
public enum PropertyBuilder {
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case platform(PlatformBuilder)
    
}

extension PropertyBuilder {
    
    public static func random(_ type: PropertyEnum) -> Self {
        switch type {
        case .series, .developer, .publisher, .genre:
            let input: InputEnum = .init(type)
            let builder: InputBuilder = .init(input, .random)
            return .input(builder)
        case .mode:
            let mode: ModeEnum = .random
            return .mode(mode)
        case .platform:
            let system: SystemBuilder = .random
            let format: FormatBuilder = .random
            let builder: PlatformBuilder = .init(system, format)
            return .platform(builder)
        }
    }
    
    public static var random: Self {
        .random(.random)
    }
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let snapshot: PropertySnapshot = model.snapshot
        return .fromSnapshot(snapshot)
    }
    
    public static func fromSnapshot(_ snapshot: PropertySnapshot) -> Self {
        let type: PropertyEnum = snapshot.type
        let canon: String = snapshot.string.canon
        let trim: String = snapshot.string.trim
            
        switch type {
        case .series, .developer, .publisher, .genre:
            let input: InputEnum = .init(type)
            let builder: InputBuilder = .init(input, trim)
            return .input(builder)
        case .mode:
            let mode: ModeEnum = .init(canon)
            return .mode(mode)
        case .platform:
            let system: SystemBuilder = .init(canon)
            let format: FormatBuilder = .init(trim)
            let builder: PlatformBuilder = .init(system, format)
            return .platform(builder)
        }
    }
    
    public var type: PropertyEnum {
        switch self {
        case .input(let inputBuilder):
            switch inputBuilder.type {
            case .series: return .series
            case .developer: return .developer
            case .publisher: return .publisher
            case .genre: return .genre
            }
        case .mode: return .mode
        case .platform: return .platform
        }
    }
    
    public var stringBuilder: StringBuilder {
        .fromPropertyBuilder(self)
    }
    
}
