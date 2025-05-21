//
//  RelationModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/21/25.
//

import Foundation
import SwiftData

// TODO: complete these for relation

public enum RelationEnum: Enumerable {
    case game, property
}

@Model
public class RelationModel: Persistable {
    
//    public static func fromSnapshot(_ snapshot: GameSnapshot) -> GameModel {
//        let uuid: UUID = snapshot.uuid
//        return .init(uuid: uuid).updateFromSnapshot(snapshot)
//    }
    
    public private(set) var uuid: UUID
    
    public private(set) var type_id: String
    public private(set) var uuid_1: UUID
    public private(set) var uuid_2: UUID
    
    private init(uuid: UUID) {
        let today: Date = .defaultValue
        self.uuid = uuid
        self.type_id = .defaultValue
        self.uuid_1 = uuid
        self.uuid_2 = uuid
    }

}

//public extension GameModel {
//    
//    @discardableResult
//    func setStatus(_ status: GameStatusEnum) -> GameModel {
//        self.status_bool = status.bool
//        return self
//    }
//    
//    @discardableResult
//    func updateFromSnapshot(_ snap: GameSnapshot) -> GameModel {
//        self.title_canon = snap.title_canon
//        self.title_trim = snap.title_trim
//        self.release_date = snap.release_date
//        self.status_bool = snap.status_bool
//        self.boxart_data = snap.boxart
//        return self
//    }
//    
//    var snapshot: GameSnapshot {
//        .fromModel(self)
//    }
//    
//}

public enum RelationBuilder {
    case game(GameBuilder)
    case input(InputBuilder)
    case mode(ModeEnum)
    case system(SystemBuilder)
    case format(FormatBuilder)
    
//    case platform(SystemBuilder, FormatBuilder)
//    case foo(GameBuilder, RelationBuilder)
}

public struct RelationSnapshot {
    
    let uuid: UUID
    let game: GameSnapshot
    let builder: RelationBuilder
    
    private init(_ game: GameSnapshot, _ builder: RelationBuilder) {
        self.uuid = .init()
        self.game = game
        self.builder = builder
    }
    
}
