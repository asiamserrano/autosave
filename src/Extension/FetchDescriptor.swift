//
//  FetchDescriptor.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

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
//    
    static func getByStatus(_ status: GameStatusEnum) -> Self {
        let bool = status.bool
        let predicate: GamePredicate = .getForList(bool, .defaultValue)
        return .init(predicate: predicate, sortBy: .defaultValue)
    }
    
//    static func getByJunctions(_ junctions: [LinkModel]) -> Self {
//        let uuids: [UUID] = junctions.compactMap(\.game_uuid)
//        let predicate: GamePredicate = .getByUUIDs(uuids)
//        return .init(predicate: predicate, sortBy: .defaultValue)
//    }
    
}
