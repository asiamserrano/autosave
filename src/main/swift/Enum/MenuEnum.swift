//
//  MenuEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

import Foundation

public enum MenuEnum: Encapsulable {
    
    
    public static var allCases: Cases {
        ModelEnum.cases.flatMap { type in
            switch type {
            case .game:
                return GameStatusEnum.cases.map(Self.game)
            case .property:
                return Cases.init(.properties)
            case .relation:
                return .defaultValue
            }
        }
    }
    
    case game(GameStatusEnum)
    case properties
    
    public var enumeror: Enumeror {
        switch self {
        case .game(let status):
            return status
        case .properties:
            return ConstantEnum.properties
        }
    }
    
}

public extension MenuEnum {
    
    var icon: IconEnum {
        switch self {
        case .game(let status):
            return status.icon
        case .properties:
            return .list_clipboard
        }
    }
    
}
