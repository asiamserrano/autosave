//
//  RelationModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/21/25.
//

import Foundation
import SwiftData


// TODO: continue here with Relation model revamp
@Model
public class RelationModel: Persistable {
    
    public var uuid: UUID
    public var key_model_uuid: UUID
    public var value_model_uuid: UUID
    public var type_id: String
    
    public init(_ uuid: UUID = .init()) {
        self.uuid = uuid
        self.key_model_uuid = uuid
        self.value_model_uuid = uuid
        self.type_id = .defaultValue
    }
}

enum RelationType: Enumerable {
    case gameProperty      // game ↔︎ property (simple)
    case gamePlatform      // game ↔︎ platform (compound)
    case platformDefinition // platform = system + format
}


//
//@Model
//public class RelationModel: Persistable {
//    
//    public static func fromSnapshot(_ snapshot: RelationSnapshot) -> RelationModel {
//        let model: RelationModel = .init()
//        model.type_id = snapshot.type_id
//        model.game_uuid = snapshot.game_uuid
//        model.property_key_uuid = snapshot.property_key_uuid
//        model.property_value_uuid = snapshot.property_value_uuid
//        return model
//    }
//    
//    public private(set) var uuid: UUID
//    public private(set) var type_id: String
//    public private(set) var game_uuid: UUID
//    public private(set) var property_key_uuid: UUID
//    public private(set) var property_value_uuid: UUID
//    public private(set) var count: Int
//    
//    private init(_ uuid: UUID = .init()) {
//        self.uuid = uuid
//        self.type_id = .defaultValue
//        self.game_uuid = uuid
//        self.property_key_uuid = uuid
//        self.property_value_uuid = uuid
//        self.count = .one
//    }
//    
//    @discardableResult
//    func increment() -> RelationModel {
//        self.count += 1
//        return self
//    }
//
//    public var type: RelationBase {
//        .init(self.type_id)
//    }
//    
//}
//
//public enum RelationBase: Encapsulable {
//    
//    public static var allCases: [Self] {
//        var properties: [Self] = PropertyBase.cases.map(Self.property)
//        properties.append(.platform)
//        return properties
//    }
//    
//    case property(PropertyBase)
//    case platform
//    
//    public var isIncrementable: Bool {
//        switch self {
//        case .property(let property):
//            switch property {
//            case .platform:
//                return true
//            default:
//                return false
//            }
//        default:
//            return false
//        }
//    }
//    
//    public var enumeror: Enumeror {
//        switch self {
//        case .property(let propertyBase):
//            return propertyBase
//        case .platform:
//            return PropertyEnum.platform
//        }
//    }
//    
//}
//
//public enum RelationBuilder {
//    
//    public static var random: Self {
//        let property: PropertyBase = .random
//        switch property {
//        case .mode, .input:
//            let snapshot: PropertySnapshot = .random(property)
//            return .property(snapshot)
//        case .platform:
//            let builder: SystemBuilder = .random
//            let system: PropertySnapshot = .fromBuilder(.platform(.system(builder)))
//            let format: PropertySnapshot = .fromBuilder(.platform(.format(.random(builder))))
//            return .platform(system, format)
//        }
//    }
//    
//    case property(PropertySnapshot)
//    case platform(PropertySnapshot, PropertySnapshot)
//    
//    public var type: RelationBase {
//        switch self {
//        case .property(let property):
//            let base: PropertyBase = property.base
//            return .property(base)
//        case .platform:
//            return .platform
//        }
//    }
//    
//    public var key: PropertySnapshot {
//        switch self {
//        case .property(let property):
//            return property
//        case .platform(let system, _):
//            return system
//        }
//    }
//    
//    public var value: PropertySnapshot {
//        switch self {
//        case .property(let property):
//            return property
//        case .platform(_, let format):
//            return format
//        }
//    }
//    
////    public var array: [Self] {
////        switch self {
////        case .property:
////            return .init(self)
////        case .platform:
////            let system: Self = .property(self.key)
////            let format: Self = .property(self.value)
////            return .init(self, system, format)
////        }
////    }
//    
//}
//
//public struct RelationSnapshot {
//    
//    public static func fromSnapshot(_ g: GameModel, _ snapshot: PropertySnapshot) -> Self {
//        let game: GameSnapshot = g.snapshot
//        let builder: RelationBuilder = .property(snapshot)
//        return .init(game, builder)
//    }
//    
//    public static func fromBuilder(_ g: GameModel, _ builder: RelationBuilder) -> Self {
//        let game: GameSnapshot = g.snapshot
//        return .init(game, builder)
//    }
//    
//    public static func fromModel(_ game: GameModel, _ property: PropertyModel) -> Self {
//        let snapshot: PropertySnapshot = property.snapshot
//        let builder: RelationBuilder = .property(snapshot)
//        return .fromBuilder(game, builder)
//    }
//    
//    public let game: GameSnapshot
//    public let builder: RelationBuilder
//
//    private init(_ game: GameSnapshot, _ builder: RelationBuilder) {
//        self.game = game
//        self.builder = builder
//    }
//    
//    public var type_id: String {
//        self.builder.type.id
//    }
//    
//    public var game_uuid: UUID {
//        self.game.uuid
//    }
//    
//    public var property_key_uuid: UUID {
//        self.builder.key.uuid
//    }
//    
//    public var property_value_uuid: UUID {
//        self.builder.value.uuid
//    }
//    
//}
//
//
//
//
