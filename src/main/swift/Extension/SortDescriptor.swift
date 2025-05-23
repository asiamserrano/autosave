//
//  SortDescriptor.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public typealias GameSortDescriptor = SortDescriptor<GameModel>

public extension GameSortDescriptor {
    
    static func release(_ order: SortOrder) -> Self {
        .init(\.release_date, order: order)
    }
    
    static func title(_ order: SortOrder) -> Self {
        .init(\.title_trim, order: order)
    }
    
}
