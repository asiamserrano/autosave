//
//  GameStatusEnum.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation

public enum GameStatusEnum: Enumerable {
    case library, wishlist
}

public extension GameStatusEnum {
    
    static func fromBool(_ bool: Bool) -> Self {
        switch bool {
        case true: return .library
        case false: return .wishlist
        }
    }
    
    var bool: Bool {
        switch self {
        case .library: return true
        case .wishlist: return false
        }
    }
    
    var icon: IconEnum {
        switch self {
        case .wishlist: return .list_star
        case .library: return .gamecontroller
        }
    }
    
}
