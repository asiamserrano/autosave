//
//  NavigationEnum.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import Foundation

public enum NavigationEnum {
    case property(GameBuilder, InputEnum, [String])
//    case text(String)
}

extension NavigationEnum: Stable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .property(_, let inputEnum, let array):
            hasher.combine(inputEnum)
            hasher.combine(array)
//        case .text(let string):
//            let builder: StringBuilder = .string(string)
//            hasher.combine("string")
//            hasher.combine(builder)
        }
    }
    
}
