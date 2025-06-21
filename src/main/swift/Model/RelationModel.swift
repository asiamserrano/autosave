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
    
    public static func fromSnapshot(_ snapshot: RelationSnapshot) -> RelationModel {
        let relation: RelationModel = .init()
        relation.uuid = snapshot.uuid
        relation.category_id = snapshot.category_id
        relation.type_id = snapshot.type_id
        relation.game_uuid = snapshot.game_uuid
        relation.key_uuid = snapshot.key_uuid
        relation.value_uuid = snapshot.value_uuid
        return relation
    }
    
    
    
    public private(set) var uuid: UUID
    public private(set) var category_id: String
    public private(set) var type_id: String
    public private(set) var game_uuid: UUID
    public private(set) var key_uuid: UUID
    public private(set) var value_uuid: UUID
    
    
    private init(_ uuid: UUID = .init()) {
        self.uuid = uuid
        self.game_uuid = uuid
        self.key_uuid = uuid
        self.value_uuid = uuid
        self.category_id = .defaultValue
        self.type_id = .defaultValue
    }
    
}

public enum RelationCategory: Enumerable {
    case property
    case tag
}

public enum RelationType: Encapsulable {
    
    public static var allCases: Cases {
        RelationCategory.allCases.flatMap { type in
            switch type {
            case .property:
                return PropertyType.cases.map(Self.property)
            case .tag:
                return TagType.cases.map(Self.tag)
            }
        }
    }
    
    case property(PropertyType)
    case tag(TagType)
    
    public var enumeror: Enumeror {
        switch self {
        case .property(let p):
            return p
        case .tag(let t):
            return t
        }
    }
    
    public var category: RelationCategory {
        switch self {
        case .property:
            return .property
        case .tag:
            return .tag
        }
    }
    
}


public struct RelationSnapshot: Uuidentifiable {
    
    public let uuid: UUID
    public let game: Uuidentifor
    public let tag: TagSnapshot
    public let category: RelationCategory
    
    public init(_ category: RelationCategory, _ game: Uuidentifor, _ tag: TagSnapshot) {
        self.uuid = .init()
        self.category = category
        self.game = game
        self.tag = tag
    }
    
    public var game_uuid: UUID {
        self.game.uuid
    }
    
    public var key_uuid: UUID {
        self.tag.key.uuid
    }
    
    public var value_uuid: UUID {
        self.tag.value.uuid
    }
    
    public var category_id: String {
        self.category.id
    }
    
    public var type: RelationType {
        self.tag.getLabel(self.category)
    }
    
    public var type_id: String {
        self.type.id
    }
    
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
