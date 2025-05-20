//
//  PlatformBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum PlatformBuilder: Encapsulable {
    
    public static var allCases: Cases {
        PlatformEnum.allCases.flatMap { category in
            switch category {
            case .system:
                return SystemBuilder.cases.map(Self.system)
            case .format:
                return FormatBuilder.cases.map(Self.format)
            }
        }
    }

    case system(SystemBuilder)
    case format(FormatBuilder)

    public var enumeror: Enumeror {
        switch self {
        case .system(let system):
            return system
        case .format(let format):
            return format
        }
    }

}

extension PlatformBuilder {
    
    public static func random(_ platform: PlatformBase) -> Self {
        switch platform {
        case .system(let system): return .system(.random(system))
        case .format(let format): return .format(.random(format))
        }
    }
    
}
