//
//  RelationBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/24/25.
//

import Foundation

public struct RelationBuilder {
    
//    public static func fromModels(_ game: GameModel, _ property: PropertyModel) -> Self {
//        let key: GameSnapshot = game.snapshot
//        let value: PropertySnapshot = property.snapshot
//        return .init(.game_to_property, key, value)
//    }
//    
//    public static func fromModels(_ game: GameModel, _ value: RelationModel) -> Self {
//        let key: GameSnapshot = game.snapshot
//        return .init(.game_to_relation, key, value)
//    }
//    
//    public static func fromModels(_ system: PropertyModel, _ format: PropertyModel) -> Self {
//        let key: PropertySnapshot = system.snapshot
//        let value: PropertySnapshot = format.snapshot
//        return .init(.property_to_property, key, value)
//    }
    
    public let type: RelationEnum
    public let key: Uuidentifor
    public let value: Uuidentifor
    
    public init(_ type: RelationEnum, _ key: Uuidentifor, _ value: Uuidentifor) {
        self.type = type
        self.key = key
        self.value = value
    }
    
}

//public enum RelationBuilder {
//    
//    case game_to_property(GameSnapshot, PropertySnapshot)
//    case game_to_relation(GameSnapshot, RelationModel)
//    case property_to_property(PropertySnapshot, PropertySnapshot)
//    
//}
//
//extension RelationBuilder {
//    
//    public var type: RelationEnum {
//        switch self {
//        case .game_to_property: return .game_to_property
//        case .game_to_relation: return .game_to_relation
//        case .property_to_property: return .property_to_property
//        }
//    }
//    
//    public var key: Uuidentifor {
//        switch self {
//        case .game_to_property(let game, _):
//            return game
//        case .game_to_relation(let game, _):
//            return game
//        case .property_to_property(let property, _):
//            return property
//        }
//    }
//    
//    public var value: Uuidentifor {
//        switch self {
//        case .game_to_property(_, let property):
//                return property
//        case .game_to_relation(_, let relation):
//            return relation
//        case .property_to_property(_, let property):
//            return property
//        }
//    }
//    
//}
