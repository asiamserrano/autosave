//
//  FormatBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum FormatBuilder: Enumerable {
    
    public static var allCases: [Self] {
      FormatEnum.allCases.flatMap { category in
        switch category {
          case .digital:
            return DigitalEnum.cases.map(Self.digital)
          case .physical:
            return PhysicalEnum.cases.map(Self.physical)
        }
      }
    }
    
    public enum DigitalEnum: Enumerable {
        case steam, origin, psn, xbox, nintendo, free
    }
    
    public enum PhysicalEnum: Enumerable {
        case disc, cartridge, card
    }
    
    case digital(DigitalEnum)
    case physical(PhysicalEnum)
    
    public var formatEnum: FormatEnum {
        switch self {
        case .digital:  return .digital
        case .physical: return .physical
        }
    }
    
    private var format: any Enumerable {
        switch self {
        case .digital(let digitalEnum): return digitalEnum
        case .physical(let physicalEnum): return physicalEnum
        }
    }
    
    public var id: String {
        "\(self.formatEnum.id)_\(self.format.id)"
    }
    
    public var rawValue: String {
        switch self {
        case .physical(let p): return p.rawValue
        case .digital(let d):
            switch d {
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
