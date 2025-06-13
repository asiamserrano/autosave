//
//  SortOrder.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

extension SortOrder: Iterable {
    
    public static var defaultValue: Self { .forward }
    
    public static var cases: [SortOrder] { [.forward, .reverse] }
    
    public var icon: IconEnum {
        switch self {
        case .forward:
            return .chevron_up
        case .reverse:
            return .chevron_down
        }
    }
    
}
