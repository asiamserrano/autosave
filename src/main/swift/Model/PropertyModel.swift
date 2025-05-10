//
//  PropertyModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation
import SwiftData

@Model
public class PropertyModel {
    
//    public static func fromBuilder(_ builder: PropertyBuilder) -> PropertyModel {
//        let snapshot: PropertySnapshot = .fromBuilder(builder)
//        return .fromSnapshot(snapshot)
//    }
    
    public static func fromSnapshot(_ snapshot: PropertySnapshot) -> PropertyModel {
        let uuid: UUID = snapshot.uuid
        return .init(uuid: uuid).updateFromSnapshot(snapshot)
    }
    
    public private(set) var uuid: UUID
    public private(set) var type_id: String
    public private(set) var value_canon: String
    public private(set) var value_trim:  String
    
    private init(uuid: UUID) {
        self.uuid = uuid
        self.type_id = .defaultValue
        self.value_canon = .defaultValue
        self.value_trim = .defaultValue
    }
    
    @discardableResult
    func updateFromSnapshot(_ snap: PropertySnapshot) -> PropertyModel {
        self.type_id = snap.type_id
        self.value_canon = snap.value_canon
        self.value_trim = snap.value_trim
        return self
    }
    
    var snapshot: PropertySnapshot {
        .fromModel(self)
    }
    
}









