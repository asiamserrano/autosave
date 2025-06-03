//
//  FetchDescriptor.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

public extension FetchDescriptor {
    
    static var defaultValue: Self { .init() }
    
}

public typealias GameFetchDescriptor = FetchDescriptor<GameModel>

public extension GameFetchDescriptor {
    
    static func getByCompositeKey(_ snapshot: GameSnapshot) -> Self {
        let title_canon: String = snapshot.title_canon
        let release_date: String = snapshot.release_date
        let predicate: GamePredicate = .getByCompositeKey(title_canon, release_date)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
    static func getByUUID(_ snapshot: GameSnapshot) -> Self {
        let uuid: UUID = snapshot.uuid
        let predicate: GamePredicate = .getByUUID(uuid)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
    static func getByStatus(_ status: GameStatusEnum) -> Self {
        let bool = status.bool
        let predicate: GamePredicate = .getForList(bool, .defaultValue)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
//    static func getByRelations(_ relations: [RelationModel]) -> Self {
//        let uuids: [UUID] = relations.compactMap(\.uuid_key)
//        let predicate: GamePredicate = .getByUUIDs(uuids)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
    
}

public typealias PropertyFetchDescriptor = FetchDescriptor<PropertyModel>

public extension PropertyFetchDescriptor {
    
    static func getByCompositeKey(_ snapshot: PropertySnapshot) -> Self {
        let type_id: String = snapshot.type_id
        let value_canon: String = snapshot.value_canon
        let predicate: PropertyPredicate = .getByCompositeKey(type_id, value_canon)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
    static func getByUUID(_ snapshot: PropertySnapshot) -> Self {
        let uuid: UUID = snapshot.uuid
        let predicate: PropertyPredicate = .getByUUID(uuid)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
//    static func getByType(_ property: PropertyBase) -> Self {
//        let type_id: String = property.id
//        let predicate: PropertyPredicate = .getByType(type_id)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
    
}

public typealias RelationFetchDescriptor = FetchDescriptor<RelationModel>

public extension RelationFetchDescriptor {
    
    static func getByCompositeKey(_ snapshot: RelationSnapshot) -> Self {
        let type: String = snapshot.type_id
        let game: UUID = snapshot.game_uuid
        let key: UUID = snapshot.property_key_uuid
        let value: UUID = snapshot.property_value_uuid
        let predicate: RelationPredicate = .getByCompositeKey(type, game, key, value)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
}
