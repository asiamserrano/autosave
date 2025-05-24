//
//  RelationSnapshot.swift
//  autosave
//
//  Created by Asia Serrano on 5/24/25.
//

import Foundation

public struct RelationSnapshot: Uuidentifiable {
    
    public static func fromModels(_ game: GameModel, _ property: PropertyModel) -> Self {
        let key: GameSnapshot = game.snapshot
        let value: PropertySnapshot = property.snapshot
        let builder: RelationBuilder = .init(.game_to_property, key, value)
        return .fromBuilder(builder)
    }
    
    public static func fromModels(_ game: GameModel, _ value: RelationModel) -> Self {
        let key: GameSnapshot = game.snapshot
        let builder: RelationBuilder = .init(.game_to_relation, key, value)
        return .fromBuilder(builder)
    }
    
    public static func fromModels(_ system: PropertyModel, _ format: PropertyModel) -> Self {
        let key: PropertySnapshot = system.snapshot
        let value: PropertySnapshot = format.snapshot
        let builder: RelationBuilder = .init(.property_to_property, key, value)
        return .fromBuilder(builder)
    }
    
    public static func fromBuilder(_ builder: RelationBuilder) -> Self {
        let type: RelationEnum = builder.type
        let key: UUID = builder.key.uuid
        let value: UUID = builder.value.uuid
        return .init(type, key, value)
    }
    
    public let uuid: UUID
    public let type: RelationEnum
    public let key: UUID
    public let value: UUID
    
    private init(_ type: RelationEnum, _ key: UUID, _ value: UUID) {
        self.uuid = .init()
        self.type = type
        self.key = key
        self.value = value
    }
//    
//    private init(_ builder: RelationBuilder) {
//        self.uuid = .init()
//        self.builder = builder
////        self.type = builder.type
////        self.key = builder.key
////        self.value = builder.value
//    }
    
//    public var type: RelationEnum {
//        self.builder.type
//    }
//    
//    public var key: UUID {
//        self.builder.key.uuid
//    }
//    
//    public var value: UUID {
//        self.builder.value.uuid
//    }

//    private init(_ type: RelationEnum, _ key: Uuidentifor, _ value: Uuidentifor) {
//        self.uuid = .init()
//        self.type = type
//        self.key = key
//        self.value = value
//    }
    
}
