//
//  SortDescriptor.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public typealias GameSortDescriptor = SortDescriptor<GameModel>

public extension GameSortDescriptor {
    
//    static func release(_ order: SortOrder) -> Self {
//        .init(\.release_date, order: order)
//    }
//    
//    static func title(_ order: SortOrder) -> Self {
//        .init(\.title_trim, order: order)
//    }
    
//    static func fromGameSort(_ sort: GameSort) -> Self {
//        let keyPath = sort.keyPath
//        let order = sort.order
//        return .init(keyPath, order: order)
//    }
    
}

public typealias PropertySortDescriptor = SortDescriptor<PropertyModel>

public extension PropertySortDescriptor {
    
    static var category: Self {
        .init(\.category_id, order: .forward)
    }
    
    static var type: Self {
        .init(\.type_id, order: .forward)
    }
    
    static var label: Self {
        .init(\.label_id, order: .forward)
    }
    
    static var value: Self {
        .init(\.value_canon, order: .forward)
    }
    
}
