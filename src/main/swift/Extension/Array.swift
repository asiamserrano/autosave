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
        [
            GameModel.self
        ]
    }
    
}

extension Array where Element == GameSortDescriptor {
    
    private static func byRelease(_ sort: SortOrder) -> Self {
        .init(arrayLiteral: .release(sort), .title(.forward))
    }
    
    private static func byTitle(_ sort: SortOrder) -> Self {
        .init(arrayLiteral: .title(sort), .release(.forward))
    }
    
    public static func defaultValue(_ sort: GameSort) -> Self {
        let order: SortOrder = sort.order
        switch sort.type {
        case .release: return .byRelease(order)
        case .title: return .byTitle(order)
        }
    }
    
}
