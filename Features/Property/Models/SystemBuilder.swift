//
//  SystemBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum SystemBuilder: Enumerable {
    
    public static var allCases: [Self] {
      SystemEnum.allCases.flatMap { category in
        switch category {
          case .playstation:
            return PlayStationEnum.cases.map(Self.playstation)
          case .nintendo:
            return NintendoEnum.cases.map(Self.nintendo)
        case .xbox:
            return XboxEnum.cases.map(Self.xbox)
        case .os:
            return OSEnum.allCases.map(Self.os)
        case .mq3:
            return .init()
        }
      }
    }
    
    public enum PlayStationEnum: Enumerable {
        case ps1, ps2, ps3, ps4, ps5, psp
    }
    
    public enum NintendoEnum: Enumerable {
        case snes, nsw, wii, wiiu, gamecube, n3ds
    }
    
    public enum OSEnum: Enumerable {
        case win, mac
    }
    
    public enum XboxEnum: Enumerable {
        case xbox, x360, one
    }
    
    case playstation(PlayStationEnum)
    case nintendo(NintendoEnum)
    case xbox(XboxEnum)
    case os(OSEnum)
    
    public var systemEnum: SystemEnum {
        switch self {
        case .playstation: return .playstation
        case .nintendo: return .nintendo
        case .xbox: return .xbox
        case .os: return .os
        }
    }
    
    private var system: any Enumerable {
        switch self {
        case .playstation(let p): return p
        case .nintendo(let n): return n
        case .xbox(let x): return x
        case .os(let o): return o
        }
    }
    
    public var id: String {
        "\(self.systemEnum.id)_\(self.system.id)"
    }
    
    public var rawValue: String {
        switch self {
        case .playstation(let p):
            switch p {
            case .ps1: return "PlayStation"
            case .ps2: return "PlayStation 2"
            case .ps3: return "PlayStation 3"
            case .ps4: return "PlayStation 4"
            case .ps5: return "PlayStation 5"
            case .psp: return "PlayStation Portable"
            }
        case .nintendo(let n):
            switch n {
            case .snes: return "Super Nintendo Entertainment System"
            case .nsw: return "Nintendo Switch"
            case .wii: return "Wii"
            case .wiiu : return "Wii U"
            case .gamecube: return "GameCube"
            case .n3ds: return "Nintendo 3DS"
            }
        case .xbox(let x):
            switch x {
            case .xbox: return "Xbox"
            case .x360: return "360"
            case .one:  return "One"
            }
        case .os(let o):
            switch o {
            case .win: return "Microsoft Windows"
            case .mac: return "Apple macOS"
            }
        }
    }
    
}
