//
//  SortDescriptor.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public typealias GameSortDescriptor = SortDescriptor<GameModel>

fileprivate extension GameSortDescriptor {
    
    static func release(_ order: SortOrder) -> Self {
        .init(\.release_date, order: order)
    }
    
    static func title(_ order: SortOrder) -> Self {
        .init(\.title_trim, order: order)
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
