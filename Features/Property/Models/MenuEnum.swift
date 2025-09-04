//
//  MenuEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

import Foundation

public enum MenuEnum: Enumerable {
    case library
    case wishlist
    case properties
}

public extension MenuEnum {
    
    var icon: AppIcon {
        switch self {
        case .properties: return .list_clipboard
        case .wishlist: return .list_star
        case .library: return .gamecontroller
        }
    }
    
}
