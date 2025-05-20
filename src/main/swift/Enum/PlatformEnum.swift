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
    
    public func equals(_ base: PlatformBase) -> Bool {
        switch base {
        case .system: return self == .system
        case .format: return self == .format
        }
    }
    
    public func equals(_ builder: PlatformBuilder) -> Bool {
        switch builder {
        case .system: return self == .system
        case .format: return self == .format
        }
    }
    
    public var type_id: String {
        switch self {
        case .system: 
        case .format:
            <#code#>
        }
    }
    
}
