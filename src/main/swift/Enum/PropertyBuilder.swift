//
//  PropertyBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum PropertyBuilder {
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case platform(PlatformBuilder)
    
}

extension PropertyBuilder {
    
    public static func random(_ base: PropertyBase) -> Self {
        switch base {
        case .input(let input):
            let builder: InputBuilder = .init(input, .random)
            return .input(builder)
        case .mode:
            let mode: ModeEnum = .random
            return .mode(mode)
        case .platform:
            let builder: PlatformBuilder = .random
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
        let base: PropertyBase = snapshot.base
        let canon: String = snapshot.string.canon
        let trim: String = snapshot.string.trim
            
        switch base {
        case .input(let input):
            let builder: InputBuilder = .init(input, trim)
            return .input(builder)
        case .mode:
            let mode: ModeEnum = .init(canon)
            return .mode(mode)
        case .platform:
            let builder: PlatformBuilder = .init(canon)
            return .platform(builder)
        }
    }
    
    public var stringBuilder: StringBuilder {
        .fromPropertyBuilder(self)
    }
    
}
