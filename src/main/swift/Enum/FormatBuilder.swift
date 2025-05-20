//
//  FormatBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum FormatBuilder: Encapsulable {
    
    public static var allCases: Cases {
      FormatEnum.allCases.flatMap { category in
        switch category {
          case .digital:
            return DigitalEnum.cases.map(Self.digital)
          case .physical:
            return PhysicalEnum.cases.map(Self.physical)
        }
      }
    }
    
    case digital(DigitalEnum)
    case physical(PhysicalEnum)
    
    public var enumeror: Enumeror {
        switch self {
        case .digital(let digitalEnum): return digitalEnum
        case .physical(let physicalEnum): return physicalEnum
        }
    }

}

extension FormatBuilder {
    
    public static func random(_ format: FormatEnum) -> Self {
        switch format {
        case .digital: return .digital(.random)
        case .physical: return .physical(.random)
        }
    }
    
    public enum PhysicalEnum: Enumerable {
        case disc, cartridge, card
    }
    
    public enum DigitalEnum: Enumerable {
        case steam, origin, psn, xbox, nintendo, free
        
        public var rawValue: String {
            switch self {
            case .psn:      return "PlayStation Network"
            case .xbox:     return "Xbox Live"
            case .nintendo: return "Nintendo eShop"
            case .free:     return "DRM-free"
            case .origin:   return "Origin"
            case .steam:    return "Steam"
            }
        }
    }
    
}
