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
        model.uuid = snapshot.uuid
        model.type_id = snapshot.type.id
        model.uuid_key = snapshot.key
        model.uuid_value = snapshot.value
        return model
    }
    
    public private(set) var uuid: UUID
    public private(set) var type_id: String
    public private(set) var uuid_key: UUID
    public private(set) var uuid_value: UUID
    
    private init() {
        let uuid: UUID = .init()
        self.uuid = uuid
        self.type_id = .defaultValue
        self.uuid_key = uuid
        self.uuid_value = uuid
    }

}




