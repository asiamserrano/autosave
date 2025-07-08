//
//  PropertyModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation
import SwiftData

@Model
public class PropertyModel: Persistable {
    
    public static func fromSnapshot(_ snapshot: PropertySnapshot) -> PropertyModel {
        let uuid: UUID = snapshot.uuid
        return .init(uuid: uuid).updateFromSnapshot(snapshot)
    }
    
    public private(set) var uuid: UUID
    public private(set) var category_id: String
    public private(set) var type_id: String
    public private(set) var label_id: String
    public private(set) var value_canon: String
    public private(set) var value_trim:  String
    
    private init(uuid: UUID) {
        self.uuid = uuid
        self.category_id = .defaultValue
        self.type_id = .defaultValue
        self.label_id = .defaultValue
        self.value_canon = .defaultValue
        self.value_trim = .defaultValue
    }
    
    @discardableResult
    func updateFromSnapshot(_ snap: PropertySnapshot) -> PropertyModel {
        self.category_id = snap.category_id
        self.type_id = snap.type_id
        self.label_id = snap.label_id
        self.value_canon = snap.value_canon
        self.value_trim = snap.value_trim
        return self
    }

    var snapshot: PropertySnapshot {
        .fromModel(self)
    }
    
}
