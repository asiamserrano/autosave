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
    
//    public static func getByUUIDs(_ uuids: [UUID]) -> GamePredicate {
//        #Predicate {
//            uuids.contains($0.uuid)
//        }
//    }
    
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


extension PropertyPredicate {
    
    public static func getByUUID(_ uuid: UUID) -> PropertyPredicate {
        #Predicate {
            $0.uuid == uuid
        }
    }
    
    
}
