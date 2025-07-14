//
//  RelationSnapshot.swift
//  autosave
//
//  Created by Asia Serrano on 5/24/25.
//

import Foundation

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
