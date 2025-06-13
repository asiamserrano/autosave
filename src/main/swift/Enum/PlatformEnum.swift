//
//  PlatformEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import Foundation

public enum PlatformEnum: Enumerable {
    case system, format
}

extension PlatformEnum {

    public var prefix_id: String {
        switch self {
        case .system:
            return SystemEnum.className
        case .format:
            return FormatEnum.className
        }
    }
    
}
