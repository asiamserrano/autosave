//
//  Array.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

public extension Array {
    
    static var defaultValue: Self { .init() }
    
    init(_ elements: Element...) {
        self = elements
    }
    
    var randomElement: Element {
        if let element: Element = self.randomElement() {
            return element
        } else {
            fatalError("unable to get random element for empty array: \(self)")
        }
    }
    
}

extension Array where Element == any PersistentModel.Type {
    
    public static var defaultValue: Self {
        .init(GameModel.self, PropertyModel.self, RelationModel.self)
    }
    
}

extension Array where Element == GameSortDescriptor {

    public static func defaultValue(_ sort: GameSort) -> Self {
        let order: SortOrder = sort.order
        switch sort.type {
        case .release:
            return .init(.release(order), .title(.forward))
        case .title:
            return .init(.title(order), .release(.forward))
        }
    }
    
}

extension Array where Element == PropertySortDescriptor {
    
    public static var defaultValue: Self {
        .init(.type(.forward), .value(.forward))
    }
    
}

//extension Array where Element == RelationModel {
//    
//    public var keys: [UUID] {
//        self.map(\.uuid_key)
//    }
//    
//    public var values: [UUID] {
//        self.map(\.uuid_value)
//    }
//    
//}
