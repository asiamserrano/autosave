//
//  PropertyBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum PropertyBuilder {
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let snapshot: PropertySnapshot = model.snapshot
        return .fromSnapshot(snapshot)
    }
    
    public static func fromSnapshot(_ snapshot: PropertySnapshot) -> Self {
        let canon: String = snapshot.string.canon
        let trim: String = snapshot.string.trim
        switch snapshot.type {
        case .series, .developer, .publisher, .genre:
            let input: InputEnum = .init(canon)
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
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case platform(PlatformBuilder)
        
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
    
    public var stringBuilder: CanonicalString {
        .fromPropertyBuilder(self)
    }
    
//    public var stringBuilder: CanonicalString {
//        switch self {
//        case .input(let inputBuilder):
//            let key: String = inputBuilder.canon
//            let value: String = inputBuilder.trim
//            return .init(key, value)
//        case .mode(let modeEnum):
//            let key: String = modeEnum.id
//            let value: String = modeEnum.rawValue
//            return .init(key, value)
//        case .platform(PlatformBuilder):
//            let key: String = systemBuilder.id
//            let value: String = formatBuilder.id
//            return .init(key, value)
//        }
//    }
}
