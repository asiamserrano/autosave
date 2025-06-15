//
//  Array.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

public extension Array {
    
    static var defaultValue: Self { .init() }
    
    init(_ elements: Element...) {
        self = elements
    }
    
    var randomElement: Element {
        if let element: Element = self.randomElement() {
            return element
        } else {
            fatalError("unable to get random element for empty array: \(self)")
        }
    }
    
}

extension Array where Element == any PersistentModel.Type {
    
    public static var defaultValue: Self {
        .init(GameModel.self, PropertyModel.self)//, RelationModel.self)
    }
    
}

extension Array where Element == GameSortDescriptor {

    public static func defaultValue(_ sort: GameSort) -> Self {
        let order: SortOrder = sort.order
        switch sort.type {
        case .release:
            return .init(.release(order), .title(.forward))
        case .title:
            return .init(.title(order), .release(.forward))
        }
    }
    
}

extension Array where Element == PropertySortDescriptor {
    
    public static var defaultValue: Self {
        .init(.category, .type, .label, .value)
    }
    
}

//extension Array where Element == RelationModel {
//    
//    public var keys: [UUID] {
//        self.map(\.uuid_key)
//    }
//    
//    public var values: [UUID] {
//        self.map(\.uuid_value)
//    }
//    
//}

extension Array where Element == FormatBuilder {
    
    public static func getFormatBuilders(_ system: SystemBuilder) -> Self {
        let physicalBuilder: Element = getPhysicalBuilder(system)
        let digitalBuilders: Self = getDigitalBuilders(system)
        return .init(physicalBuilder) + digitalBuilders
    }
    
    private static func getPhysicalBuilder(_ system: SystemBuilder) -> Element {
        switch system {
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
    
    private static func getDigitalBuilders(_ system: SystemBuilder) -> Self {
        let free: Element = .digital(.free)
        switch system {
        case .playstation(let playstation):
            switch playstation {
            case .ps3, .ps4, .ps5:
                let p: Element = .digital(.psn)
                return .init(free, p)
            case .psp:
                return .init(free)
            default:
                return .defaultValue
            }
        case .nintendo(let nintendo):
            switch nintendo {
            case .nsw:
                let n: Element = .digital(.nintendo)
                return .init(n)
            default:
                return .defaultValue
            }
        case .xbox(let xbox):
            switch xbox {
            case .x360, .one:
                let x: Element = .digital(.xbox)
                return .init(free, x)
            default:
                return .defaultValue
            }
        case .os:
            let steam: Element = .digital(.steam)
            let origin: Element = .digital(.origin)
            return .init(steam, origin, free)
        }
    }
    
}

//extension Array where Element == RelationBuilder {
//
//    public static func fromElement(_ element: Element) -> Self {
//        switch element {
//        case .property:
//            return .init(element)
//        case .platform:
//            let system: Element = .property(element.key)
//            let format: Element = .property(element.value)
//            return .init(element, system, format)
//        }
//    }
//    
//}

//extension Array where Element == Property {
//
//    public init(_ builder: RelationBuilder) {
//        switch builder {
//        case .property(let p):
//            self.init(p)
//        case .platform(let p1, let p2):
//            self.init(p1, p2)
//        }
//    }
//    
//}

