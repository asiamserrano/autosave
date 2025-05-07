//
//  GameModel.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

@Model
public class GameModel {
    
    public static func fromSnapshot(_ snapshot: GameSnapshot) -> GameModel {
        let model: GameModel = .init(uuid: snapshot.uuid)
        return model.setSnapshot(snapshot)
    }
    
    public private(set) var uuid: UUID
    public private(set) var added: Date
    
    public private(set) var title_canon: String
    public private(set) var title_trim: String
    public private(set) var release_date: String
    public private(set) var status_bool: Bool
    public private(set) var boxart_data: Data?
    
    private init(uuid: UUID) {
        let today: Date = .defaultValue
        self.uuid = uuid
        self.added = today
        self.title_canon = .defaultValue
        self.title_trim = .defaultValue
        self.release_date = today.dashless
        self.status_bool = true
        self.boxart_data = nil
    }
    
//    public convenience init(_ snapshot: GameSnapshot) {
//        self.init(uuid: snapshot.uuid)
//        self.title_canon = snapshot.title_canon
//        self.title_trim = snapshot.title_trim
//        self.release_date = snapshot.release_date
//        self.status_bool = snapshot.status_bool
//        self.boxart_data = snapshot.boxart
//    }

}

public extension GameModel {
    
    @discardableResult
    func setStatus(_ status: GameStatusEnum) -> Self {
        self.status_bool = status.bool
        return self
    }
    
    @discardableResult
    func setSnapshot(_ snap: GameSnapshot) -> Self {
        self.title_canon = snapshot.title_canon
        self.title_trim = snapshot.title_trim
        self.release_date = snapshot.release_date
        self.status_bool = snapshot.status_bool
        self.boxart_data = snapshot.boxart
        return self
    }
    
    var snapshot: GameSnapshot {
        .fromModel(self)
    }
    
}

//public extension GameModel {
//    
//    var title: String {
//        self.title_canon
//    }
//    
//    var release: Date {
//        .fromString(self.release_date)
//    }
//    
//    var status: GameStatusEnum {
//        .fromBool(self.status_bool)
//    }
//    
//    var boxart: Data? {
//        self.boxart_data
//    }
//    
//    func equalsStatus(_ bool: Bool) -> Bool {
//        self.status_bool == bool
//    }
//    
//}
