//
//  PlatformBase.swift
//  autosave
//
//  Created by Asia Serrano on 5/19/25.
//

import Foundation

public enum PlatformBase: Encapsulable {
    
    public static var allCases: Cases {
        PlatformEnum.allCases.flatMap { category in
            switch category {
            case .system:
                return SystemEnum.cases.map(Self.system)
            case .format:
                return FormatEnum.cases.map(Self.format)
            }
        }
    }

    case system(SystemEnum)
    case format(FormatEnum)

    public var enumeror: Enumeror {
        switch self {
        case .system(let system):
            return system
        case .format(let format):
            return format
        }
    }

}

extension PlatformBase {
    
    public static func filter(_ platform: PlatformEnum) -> Cases {
        Self.cases.filter {
            switch (platform, $0) {
            case (.system, .system), (.format, .format): return true
            default: return false
            }
        }
    }
    
}
