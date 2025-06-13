//
//  FormatEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum FormatEnum: Enumerable {
    case digital, physical
}

extension FormatEnum {
    
    public var icon: IconEnum {
        switch self {
        case .digital:
            return .arrow_down_circle_fill
        case .physical:
            return .opticaldisc_fill
        }
    }
    
}
