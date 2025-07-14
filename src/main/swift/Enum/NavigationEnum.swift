//
//  NavigationEnum.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import Foundation

public enum NavigationEnum {
    case property(GameBuilder, InputEnum, [String])
    case platform(GameBuilder, SystemBuilder?, [FormatBuilder])
//    case text(String)
}

extension NavigationEnum: Stable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .property(_, let inputEnum, let array):
            hasher.combine(inputEnum)
            hasher.combine(array)
        case .platform(_, let system, let formats):
            hasher.combine(system)
            hasher.combine(formats)
//        case .text(let string):
//            let builder: StringBuilder = .string(string)
//            hasher.combine("string")
//            hasher.combine(builder)
        }
    }
    
}
