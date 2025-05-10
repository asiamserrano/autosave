//
//  PropertyModel.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation
import SwiftData

@Model
public class PropertyModel {
    
//    public static func fromBuilder(_ builder: PropertyBuilder) -> PropertyModel {
//        let snapshot: PropertySnapshot = .fromBuilder(builder)
//        return .fromSnapshot(snapshot)
//    }
    
    public static func fromSnapshot(_ snapshot: PropertySnapshot) -> PropertyModel {
        let uuid: UUID = snapshot.uuid
        return .init(uuid: uuid).updateFromSnapshot(snapshot)
    }
    
    public private(set) var uuid: UUID
    public private(set) var type_id: String
    public private(set) var value_canon: String
    public private(set) var value_trim:  String
    
    private init(uuid: UUID) {
        self.uuid = uuid
        self.type_id = .defaultValue
        self.value_canon = .defaultValue
        self.value_trim = .defaultValue
    }
    
    @discardableResult
    func updateFromSnapshot(_ snap: PropertySnapshot) -> PropertyModel {
        self.type_id = snap.type_id
        self.value_canon = snap.value_canon
        self.value_trim = snap.value_trim
        return self
    }
    
    var snapshot: PropertySnapshot {
        .fromModel(self)
    }
    
}

public struct PropertySnapshot {
    
//    public static func fromBuilder(_ builder: PropertyBuilder) -> Self {
//        let type: PropertyEnum = builder.type
//        let string: StringBuilder = .fromPropertyBuilder(builder)
//        return .init(.init(), type, string)
//    }
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let uuid: UUID = model.uuid
        let type: PropertyEnum = .init(model.type_id)
        let string: StringBuilder = .fromPropertyModel(model)
        return .init(uuid, type, string)
    }
 
    public let uuid: UUID
    public let type: PropertyEnum
    public let string: StringBuilder
    
    private init(_ uuid: UUID, _ type: PropertyEnum, _ string: StringBuilder) {
        self.uuid = uuid
        self.type = type
        self.string = string
    }

    public var type_id: String {
        self.type.id
    }
    
    public var value_canon: String {
        self.string.canon
    }
    
    public var value_trim: String {
        self.string.trim
    }
    
    public var builder: PropertyBuilder {
        .fromSnapshot(self)
    }
    
}

public enum PropertyBuilder {
    
    public static func fromModel(_ model: PropertyModel) -> Self {
        let snapshot: PropertySnapshot = model.snapshot
        return .fromSnapshot(snapshot)
    }
    
    public static func fromSnapshot(_ snapshot: PropertySnapshot) -> Self {
        let canon: String = snapshot.string.canon
        let trim: String = snapshot.string.trim
        switch snapshot.type {
        case .series, .developer, .publisher, .genre:
            let input: InputEnum = .init(canon)
            let builder: InputBuilder = .init(input, trim)
            return .input(builder)
        case .mode:
            let mode: ModeEnum = .init(canon)
            return .mode(mode)
        case .platform:
            let system: SystemBuilder = .init(canon)
            let format: FormatBuilder = .init(trim)
            let builder: PlatformBuilder = .init(system, format)
            return .platform(builder)
        }
    }
    
    case input(InputBuilder)
    case mode(ModeEnum)
    case platform(PlatformBuilder)
        
    public var type: PropertyEnum {
        switch self {
        case .input(let inputBuilder):
            switch inputBuilder.type {
            case .series: return .series
            case .developer: return .developer
            case .publisher: return .publisher
            case .genre: return .genre
            }
        case .mode: return .mode
        case .platform: return .platform
        }
    }
    
    public var stringBuilder: StringBuilder {
        .fromPropertyBuilder(self)
    }
    
//    public var stringBuilder: StringBuilder {
//        switch self {
//        case .input(let inputBuilder):
//            let key: String = inputBuilder.canon
//            let value: String = inputBuilder.trim
//            return .init(key, value)
//        case .mode(let modeEnum):
//            let key: String = modeEnum.id
//            let value: String = modeEnum.rawValue
//            return .init(key, value)
//        case .platform(PlatformBuilder):
//            let key: String = systemBuilder.id
//            let value: String = formatBuilder.id
//            return .init(key, value)
//        }
//    }
}

public enum PropertyEnum: Enumerable {
    case series
    case developer
    case publisher
    case genre
    case mode
    case platform
}

public enum ModeEnum: Enumerable {
    
    case single, two, multi
    
    public var rawValue: String {
        switch self {
        case .single: return "Single-Player"
        case .two: return "Two-Player"
        case .multi: return "Multiplayer"
        }
    }
    
    var icon: IconEnum {
        switch self {
        case .single: return .person_fill
        case .two: return .person_2_fill
        case .multi: return .person_3_fill
        }
    }
    
}

public enum InputEnum: Enumerable {
    case series,  developer, publisher, genre
}

public struct InputBuilder {
    
    let type: InputEnum
    let string: String
    
    public init(_ t: InputEnum, _ s: String) {
        self.type = t
        self.string = s
    }
    
    public var canon: String {
        self.string.canonicalized
    }
    
    public var trim: String {
        self.string.trimmed
    }
    
}

public enum SystemEnum: Enumerable {
    case playstation, nintendo, xbox, os, mq3
    
    public var rawValue: String {
        switch self {
        case .playstation: return "PlayStation"
        case .nintendo: return "Nintendo"
        case .xbox: return "Xbox"
        case .os: return "Operating System"
        case .mq3: return "Meta Quest 3"
        }
    }
    
}

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

public enum FormatEnum: Enumerable {
    case digital, physical
    
    public var icon: IconEnum {
        switch self {
        case .digital: return .arrow_down_circle_fill
        case .physical: return .opticaldisc_fill
        }
    }
}

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


public struct PlatformBuilder {
    
    let system: SystemBuilder
    let format: FormatBuilder
    
    public init(_ system: SystemBuilder, _ format: FormatBuilder) {
        self.system = system
        self.format = format
    }
    
}
