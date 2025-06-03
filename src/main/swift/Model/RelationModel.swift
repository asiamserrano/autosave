//
//  RelationModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/21/25.
//

import Foundation
import SwiftData

@Model
public class RelationModel: Persistable {
    
    public static func fromSnapshot(_ snapshot: RelationSnapshot) -> RelationModel {
        let model: RelationModel = .init()
        model.type_id = snapshot.type_id
        model.game_uuid = snapshot.game_uuid
        model.property_key_uuid = snapshot.property_key_uuid
        model.property_value_uuid = snapshot.property_value_uuid
        return model
    }
    
    public private(set) var uuid: UUID
    public private(set) var type_id: String
    public private(set) var game_uuid: UUID
    public private(set) var property_key_uuid: UUID
    public private(set) var property_value_uuid: UUID
    public private(set) var count: Int
    
    private init(_ uuid: UUID = .init()) {
        self.uuid = uuid
        self.type_id = .defaultValue
        self.game_uuid = uuid
        self.property_key_uuid = uuid
        self.property_value_uuid = uuid
        self.count = .one
    }
    
    @discardableResult
    func increment() -> RelationModel {
        self.count += 1
        return self
    }

    public var type: RelationEnum {
        .init(self.type_id)
    }
    
}

public enum RelationEnum: Encapsulable {
    
    public static var allCases: [Self] {
        var properties: [Self] = PropertyBase.cases.map(Self.property)
        properties.append(.platform)
        return properties
    }
    
    case property(PropertyBase)
    case platform
    
    public var isIncrementable: Bool {
        switch self {
        case .property(let property):
            switch property {
            case .platform:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
    
    public var enumeror: Enumeror {
        switch self {
        case .property(let propertyBase):
            return propertyBase
        case .platform:
            return PropertyEnum.platform
        }
    }
    
}

public enum RelationBase {
    
    public static var random: Self {
        let property: PropertyBase = .random
        switch property {
        case .mode, .input:
            let snapshot: PropertySnapshot = .random(property)
            return .property(snapshot)
        case .platform:
            let systemBuilder: SystemBuilder = .random
            let systemPlatform: PlatformBuilder = .system(systemBuilder)
            let systemProperty: PropertyBuilder = .platform(systemPlatform)
            let system: PropertySnapshot = .fromBuilder(systemProperty)
            
            let formatBuilder: FormatBuilder = .random(systemBuilder)
            let formatPlatform: PlatformBuilder = .format(formatBuilder)
            let formatProperty: PropertyBuilder = .platform(formatPlatform)
            let format: PropertySnapshot = .fromBuilder(formatProperty)
            
            return .platform(system, format)
        }
    }
    
    case property(PropertySnapshot)
    case platform(PropertySnapshot, PropertySnapshot)
    
    public var type: RelationEnum {
        switch self {
        case .property(let property):
            let base: PropertyBase = property.base
            return .property(base)
        case .platform:
            return .platform
        }
    }
    
    public var key: PropertySnapshot {
        switch self {
        case .property(let property):
            return property
        case .platform(let system, _):
            return system
        }
    }
    
    public var value: PropertySnapshot {
        switch self {
        case .property(let property):
            return property
        case .platform(_, let format):
            return format
        }
    }
    
    public var bases: [Self] {
        switch self {
        case .property:
            return .init(self)
        case .platform:
            let system: Self = .property(key)
            let format: Self = .property(value)
            return .init(self, system, format)
        }
    }
    
}

public struct RelationSnapshot {
    
    public static func fromBase(_ g: GameModel, _ b: RelationBase) -> Self {
        let game: GameSnapshot = g.snapshot
        let type: RelationEnum = b.type
        let key: PropertySnapshot = b.key
        let value: PropertySnapshot = b.value
        return .init(type, game, key, value)
    }
    
    public static func fromModel(_ game: GameModel, _ property: PropertyModel) -> Self {
        let snapshot: PropertySnapshot = property.snapshot
        let base: RelationBase = .property(snapshot)
        return .fromBase(game, base)
    }
    
    
    
//    public static func fromPropertySnapshot(_ game: GameModel, _ p: PropertySnapshot) -> Self {
//        let builder: PropertyBuilder = p.builder
//        let base: RelationBase = .property(builder)
//        return .fromBase(game, base)
//    }
    
//    public static func random(_ g: GameModel, _ base: RelationBase) -> [Self] {
//        let game: GameSnapshot = g.snapshot
//        let snapshot: Self = .init(game, base)
//        switch base {
//        case .property:
//            return .init(snapshot)
//        case .platform:
//            let system: Self = .init(game, snapshot.key)
//            let format: Self = .init(game, snapshot.value)
//            return .init(snapshot, system, format)
//        }
//    }
    
    public let type: RelationEnum
    public let game: GameSnapshot
    public let key: PropertySnapshot
    public let value: PropertySnapshot
    
//    private init(_ game: GameSnapshot, _ base: RelationBase) {
//        self.type = base.type
//        self.game = game
//        self.key = base.key
//        self.value = base.value
//    }
//    
//    private init(_ game: GameSnapshot, _ property: PropertySnapshot) {
//        let builder: PropertyBuilder = property.builder
//        let base: RelationBase = .property(builder)
//        self.init(game, base)
//    }
    
    private init( _ type: RelationEnum, _ game: GameSnapshot, _ key: PropertySnapshot, _ value: PropertySnapshot) {
        self.type = type
        self.game = game
        self.key = key
        self.value = value
    }
    
    public var type_id: String {
        self.type.id
    }
    
    public var game_uuid: UUID {
        self.game.uuid
    }
    
    public var property_key_uuid: UUID {
        self.key.uuid
    }
    
    public var property_value_uuid: UUID {
        self.value.uuid
    }
    
}




