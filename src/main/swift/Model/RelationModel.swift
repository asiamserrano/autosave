//
//  RelationModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/21/25.
//

import Foundation
import SwiftData

public enum RelationEnum: Enumerable {
    case input
    case mode
//    case system
//    case format
    case platform
}

@Model
public class RelationModel {
    
//    public static func fromSnapshot(_ snapshot: RelationSnapshot) -> RelationModel {
//        let model: RelationModel = .init()
//        model.uuid = snapshot.uuid
//        model.type_id = snapshot.type.id
//        model.uuid_key = snapshot.key
//        model.uuid_value = snapshot.value
//        return model
//    }
    
    public private(set) var type_id: String
    public private(set) var game_uuid: UUID
    public private(set) var property_uuid_key: UUID
    public private(set) var property_uuid_value: UUID
    public private(set) var count: Int
    
    private init(_ uuid: UUID = .init()) {
        self.type_id = .defaultValue
        self.game_uuid = uuid
        self.property_uuid_key = uuid
        self.property_uuid_value = uuid
        self.count = .zero
    }

}

public enum RelationBuilder {
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case system(SystemBuilder)
    case format(FormatBuilder)
    case platform(SystemBuilder, FormatBuilder)
    
}

public struct RelationSnapshot {
    
    public static func fromModels(_ game: GameModel, _ property: PropertyModel) -> Self {
        let
    }
    
    public let type: RelationEnum
    public let game: GameSnapshot
    public let key: PropertySnapshot
    public let value: PropertySnapshot
    
}




