//
//  GameSortEnum.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

public enum GameSortEnum: Enumerable {
    
    public static var allCases: [Self] {
        SortOrder.cases.flatMap { order in
            SortEnum.cases.map { sort in
                sort.create(order)
            }
        }
    }
    
    public var defaultValue: Self {
        .title(.defaultValue)
    }
        
    case release(SortOrder)
    case title(SortOrder)
       
}

extension GameSortEnum {
    
    public enum SortEnum: Enumerable {
        case release, title
        
        public var rawValue: String {
            switch self {
            case .release:
                return "Release Date"
            case .title:
                return "Title"
            }
        }
        
        public func create(_ order: SortOrder) -> GameSortEnum {
            switch self {
            case .release:
                return .release(order)
            case .title:
                return .title(order)
            }
        }
        
    }
    
    public var type: SortEnum {
        switch self {
        case .release:
            return .release
        case .title:
            return .title
        }
    }
    
    public var order: SortOrder {
        switch self {
        case .release(let order), .title(let order):
            return order
        }
    }
    
    public var descriptor: GameSortDescriptor {
        switch self {
        case .release(let order):
            return .init(\.release_date, order: order)
        case .title(let order):
            return .init(\.title_canon, order: order)
        }
    }
    
    public func toggle(_ type: SortEnum) -> Self {
        if self.type == type {
            return type.create(order.toggle)
        } else {
            return type.toggle.create(.defaultValue)
        }
    }
    
    public var toggleSort: Self {
        self.type.toggle.create(.defaultValue)
    }
    
    public var toggleOrder: Self {
        self.type.create(self.order.toggle)
    }
        
}
