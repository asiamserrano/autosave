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
    
}

extension Array where Element == any PersistentModel.Type {
    
    public static var defaultValue: Self {
        .init(GameModel.self, PropertyModel.self)
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
