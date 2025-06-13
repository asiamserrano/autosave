//
//  Predicate.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData

public typealias GamePredicate = Predicate<GameModel>

extension GamePredicate {
    
//    public static func getForList(_ status: GameStatusEnum, _ search: String) -> GamePredicate {
//        let canon = search.canonicalize()
//        let bool = status.bool
//        switch canon.count {
//        case 0: return #Predicate { $0.status_bool == bool }
//        case 1: return #Predicate { $0.status_bool == bool && $0.title_canon.starts(with: canon) }
//        default: return #Predicate { $0.status_bool == bool && $0.title_canon.contains(canon) }
//        }
//    }
    
    public static func getForList(_ bool: Bool, _ canon: String) -> GamePredicate {
        switch canon.count {
        case 0: return #Predicate { $0.status_bool == bool }
        case 1: return #Predicate { $0.status_bool == bool && $0.title_canon.starts(with: canon) }
        default: return #Predicate { $0.status_bool == bool && $0.title_canon.contains(canon) }
        }
    }
    
    public static func getBySearch(_ canon: String) -> GamePredicate {
        switch canon.count {
        case 0: return #Predicate { _ in true }
        case 1: return #Predicate { $0.title_canon.starts(with: canon) }
        default: return #Predicate { $0.title_canon.contains(canon) }
        }
    }
    
    public static func getByCompositeKey(_ title_canon: String, _ release_date: String) -> GamePredicate {
        #Predicate {
            $0.title_canon == title_canon && $0.release_date == release_date
        }
    }
    
    public static func getByUUID(_ uuid: UUID) -> GamePredicate {
        #Predicate {
            $0.uuid == uuid
        }
    }
    
    public static func getByUUIDs(_ uuids: [UUID]) -> GamePredicate {
        #Predicate {
            uuids.contains($0.uuid)
        }
    }
    
//    public static func getByCompositeKey(_ comparator: GameSnapshot) -> GamePredicate {
//        let title_canon: String = comparator.title_canon
//        let release_date: String = comparator.release_date
//        return #Predicate {
//            $0.title_canon == title_canon && $0.release_date == release_date
//        }
//    }
    
//    public static func getByUUID(_ comparator: GameSnapshot) -> GamePredicate {
//        let uuid: UUID = comparator.uuid
//        return #Predicate {
//            $0.uuid == uuid
//        }
//    }
    
}

public typealias PropertyPredicate = Predicate<PropertyModel>


//public enum LogicOperatorEnum: Enumerable {
//    case and, or
//}

extension PropertyPredicate {
    
    public static func getByCompositeKey(_ type_id: String, _ value_canon: String) -> PropertyPredicate {
        #Predicate {
            $0.type_id == type_id && $0.value_canon == value_canon
        }
    }
    
    
//    public static func getByUUIDs(_ key: UUID, _ value: UUID, _ logic: LogicOperatorEnum) -> PropertyPredicate {
//        switch logic {
//        case .and:
//            return #Predicate {
//                $0.uuid == key && $0.uuid == value
//            }
//        case .or:
//            return #Predicate {
//                $0.uuid == key || $0.uuid == value
//            }
//        }
//    }
    
    public static func getByUUID(_ uuid: UUID) -> PropertyPredicate {
        #Predicate {
            $0.uuid == uuid
        }
    }
    
    public static func getByUUIDs(_ uuids: [UUID]) -> PropertyPredicate {
        #Predicate {
            uuids.contains($0.uuid)
        }
    }
    
    public static func getByType(_ type_id: String) -> PropertyPredicate {
        #Predicate {
            $0.type_id == type_id || $0.type_id.contains(type_id)
        }
    }
    
    public static func getByType(_ type_id: String, _ canon: String) -> PropertyPredicate {
        switch canon.count {
        case 0: return #Predicate { $0.type_id == type_id }
        case 1: return #Predicate { $0.type_id == type_id && $0.value_canon.starts(with: canon) }
        default: return #Predicate { $0.type_id == type_id && $0.value_canon.contains(canon) }
        }
    }
    
//    public static func getByPlatform(_ type: PlatformEnum, _ platform: PlatformBuilder) -> PropertyPredicate {
//        let type_id: String = type.propertyEnum.id
//        switch type {
//        case .system:
//            let systemBuilder: SystemBuilder = platform.system
//            let systemEnum: SystemEnum = systemBuilder.systemEnum
//            let systemId: String = systemEnum.id
//            return #Predicate {
//                $0.type_id == type_id && $0.value_canon.starts(with: systemId)
//            }
//        case .format:
//            let formatBuilder: FormatBuilder = platform.format
//            let formatEnum: FormatEnum = formatBuilder.formatEnum
//            let formatId: String = formatEnum.id
//            return #Predicate {
//                $0.type_id == type_id && $0.value_trim.starts(with: formatId)
//            }
//        }
//    }
    
    
    
//    public static func getByPlatform(_ platform: PlatformEnum) -> PropertyPredicate {
//        let type_id: String = platform.propertyEnum.id
//        switch platform {
//        case .system(let system):
//            let system_id: String = system.id
//            return #Predicate {
//                $0.type_id == type_id && $0.value_canon.starts(with: system_id)
//            }
//        case .format(let format):
//            let format_id: String = format.id
//            return #Predicate {
//                $0.type_id == type_id && $0.value_trim.starts(with: format_id)
//            }
//        }
//    }
    
    
}


//public typealias RelationPredicate = Predicate<RelationModel>
//
//extension RelationPredicate {
//    
//    public static func getByCompositeKey(_ game: UUID, _ key: UUID, _ value: UUID) -> RelationPredicate {
//        #Predicate {
//            $0.game_uuid             == game
//            && $0.property_key_uuid     == key
//            && $0.property_value_uuid   == value
//        }
//    }
//    
////    public static func getByCompositeKey(_ type_id: String, _ game: UUID, _ key: UUID, _ value: UUID) -> RelationPredicate {
////        #Predicate {
////            $0.type_id                  == type_id
////            && $0.game_uuid             == game
////            && $0.property_key_uuid     == key
////            && $0.property_value_uuid   == value
////        }
////    }
//    
////    public static func getByCompositeKey(_ type_id: String, _ game: UUID, _ property: UUID) -> RelationPredicate {
////        .getByCompositeKey(type_id, game, property, property)
////    }
//    
//    public static func getByProperty(_ uuid: UUID) -> RelationPredicate {
//        #Predicate {
//            $0.property_key_uuid     == uuid
//            && $0.property_value_uuid   == uuid
//        }
//    }
//    
//    public static func getByGame(_ key: UUID) -> RelationPredicate {
//        #Predicate {
//            $0.game_uuid     == key
//        }
//    }
//
//}
