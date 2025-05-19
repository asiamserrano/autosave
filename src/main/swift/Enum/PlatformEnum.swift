//
//  PlatformEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import Foundation


public enum PlatformEnum: Encapsulable {
    
    public static var allCases: Cases {
        TypeEnum.allCases.flatMap { category in
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
        case .system(let s): return s
        case .format(let f): return f
        }
    }

}

extension PlatformEnum {
    
    public enum TypeEnum: Enumerable {
        case system, format
    }
    
}
