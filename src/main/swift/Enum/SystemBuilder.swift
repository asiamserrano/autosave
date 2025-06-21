//
//  SystemBuilder.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum SystemBuilder: Encapsulable {
    
    public static var allCases: Cases {
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
//        case .mq3:
//            return .init()
        }
      }
    }
    
    case playstation(PlayStationEnum)
    case nintendo(NintendoEnum)
    case xbox(XboxEnum)
    case os(OSEnum)

    public var enumeror: Enumeror {
        switch self {
        case .playstation(let p): return p
        case .nintendo(let n): return n
        case .xbox(let x): return x
        case .os(let o): return o
        }
    }
    
}

extension SystemBuilder {
    
    public static func random(_ system: SystemEnum) -> Self {
        switch system {
        case .playstation: return .playstation(.random)
        case .nintendo: return .nintendo(.random)
        case .xbox: return .xbox(.random)
        case .os: return .os(.random)
        }
    }
    
    public enum PlayStationEnum: Enumerable {
        case ps1, ps2, ps3, ps4, ps5, psp
        
        public var rawValue: String {
            switch self {
            case .ps1: return "PlayStation"
            case .ps2: return "PlayStation 2"
            case .ps3: return "PlayStation 3"
            case .ps4: return "PlayStation 4"
            case .ps5: return "PlayStation 5"
            case .psp: return "PlayStation Portable"
            }
        }
    }
    
    public enum NintendoEnum: Enumerable {
        case snes, nsw, wii, wiiu, gamecube, n3ds
        
        public var rawValue: String {
            switch self {
            case .snes: return "Super Nintendo Entertainment System"
            case .nsw: return "Nintendo Switch"
            case .wii: return "Wii"
            case .wiiu : return "Wii U"
            case .gamecube: return "GameCube"
            case .n3ds: return "Nintendo 3DS"
            }
        }
    }
    
    public enum OSEnum: Enumerable {
        case mac, win
        
        public var rawValue: String {
            switch self {
            case .mac: return "Apple macOS"
            case .win: return "Microsoft Windows"
            }
        }
    }
    
    public enum XboxEnum: Enumerable {
        case xbox, x360, one
        
        public var rawValue: String {
            switch self {
            case .xbox: return "Xbox"
            case .x360: return "Xbox 360"
            case .one:  return "Xbox One"
            }
        }
    }
    
    public var type: SystemEnum {
        switch self {
        case .playstation: return .playstation
        case .nintendo: return .nintendo
        case .xbox: return .xbox
        case .os: return .os
        }
    }
    
    public var formatBuilders: [FormatBuilder] {
        
        var physicalBuilder: FormatBuilder {
            switch self {
            case .nintendo(let nintendo):
                switch nintendo {
                case .snes:
                    return .physical(.cartridge)
                case .nsw, .n3ds:
                    return .physical(.card)
                default:
                    return .physical(.disc)
                }
            default:
                return .physical(.disc)
            }
        }
        
        var digitalBuilders: [FormatBuilder] {
            let free: FormatBuilder = .digital(.free)
            switch self {
            case .playstation(let playstation):
                switch playstation {
                case .ps3, .ps4, .ps5:
                    let p: FormatBuilder = .digital(.psn)
                    return .init(free, p)
                case .psp:
                    return .init(free)
                default:
                    return .defaultValue
                }
            case .nintendo(let nintendo):
                switch nintendo {
                case .nsw:
                    let n: FormatBuilder = .digital(.nintendo)
                    return .init(n)
                default:
                    return .defaultValue
                }
            case .xbox(let xbox):
                switch xbox {
                case .x360, .one:
                    let x: FormatBuilder = .digital(.xbox)
                    return .init(free, x)
                default:
                    return .defaultValue
                }
            case .os:
                let steam: FormatBuilder = .digital(.steam)
                let origin: FormatBuilder = .digital(.origin)
                return .init(steam, origin, free)
            }
        }
        
        return .init(physicalBuilder) + digitalBuilders
    }
    
}
