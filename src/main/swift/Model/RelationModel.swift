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
