//
//  Predicate.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftData
import SwiftUI

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
    
    public static func getByRelations(_ models: [RelationModel]) -> GamePredicate {
        let uuids: [UUID] = models.compactMap(\.game_uuid)
        return #Predicate {
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

extension PropertyPredicate {
    
    public static func getByCompositeKey(_ type_id: String, _ category_id: String, _ label_id: String, _ value_canon: String) -> PropertyPredicate {
        #Predicate {
            $0.type_id == type_id &&
            $0.category_id == category_id &&
            $0.label_id == label_id &&
            $0.value_canon == value_canon
        }
    }
    
    public static func getByType(_ enumeror: Enumeror) -> PropertyPredicate {
        let type_id: String = enumeror.id
        return #Predicate {
            $0.type_id == type_id
        }
    }
    
    public static func getByCategory(_ enumeror: Enumeror) -> PropertyPredicate {
        let category_id: String = enumeror.id
        return #Predicate {
            $0.category_id == category_id
        }
    }
    
    public static func getByLabel(_ enumeror: Enumeror) -> PropertyPredicate {
        let label_id: String = enumeror.id
        return #Predicate {
            $0.label_id == label_id
        }
    }
    
    public static func getByLabel(_ enumeror: Enumeror, _ search: Binding<String>) -> PropertyPredicate {
        let label_id: String = enumeror.id
        let canon = search.wrappedValue.canonicalized
        switch canon.count {
        case 0:
            return getByLabel(enumeror)
        case 1:
            return #Predicate {
                $0.label_id == label_id && $0.value_canon.starts(with: canon)
            }
        default:
            return #Predicate {
                $0.label_id == label_id && $0.value_canon.contains(canon)
            }
        }
    }
    
    public static func getByRelations(_ models: [RelationModel]) -> PropertyPredicate {
        let uuids: [UUID] = models.property_uuids
        return #Predicate {
            uuids.contains($0.uuid)
        }
    }
    
}


public typealias RelationPredicate = Predicate<RelationModel>

extension RelationPredicate {
    
    public static func getByCompositeKey(_ snapshot: RelationSnapshot) -> RelationPredicate {
        let category_id: String = snapshot.category_id
        let type_id: String = snapshot.type_id
        let game_uuid: UUID = snapshot.game_uuid
        let key_uuid: UUID = snapshot.key_uuid
        let value_uuid: UUID = snapshot.value_uuid
        return #Predicate {
            $0.category_id == category_id
            && $0.type_id  == type_id
            && $0.game_uuid == game_uuid
            && $0.key_uuid   == key_uuid
            && $0.value_uuid == value_uuid
        }
    }
    
    public static func getByProperty(_ property: PropertyModel, _ category: RelationCategory = .property) -> RelationPredicate {
        let category_id: String = category.id
        let key: UUID = property.uuid
        return #Predicate {
            $0.category_id  == category_id
            && $0.key_uuid == key
        }
    }
    
//    public static func getByGame(_ game: GameBuilder, _ tag: TagType) -> RelationPredicate {
//        let type: RelationType = .tag(tag)
//        let category_id: String = type.category.id
//        let type_id: String = type.id
//        let game: UUID = game.uuid
//        return #Predicate {
//            $0.category_id  == category_id
//            && $0.type_id == type_id
//            && $0.game_uuid == game
//        }
//    }
    
    public static func getByGame(_ game: GameBuilder, _ category: RelationCategory = .tag) -> RelationPredicate {
        let category_id: String = category.id
        let game: UUID = game.uuid
        return #Predicate {
            $0.category_id  == category_id
            && $0.game_uuid == game
        }
    }
    
}
//
////    public static func getByCompositeKey(_ type_id: String, _ game: UUID, _ property: UUID) -> RelationPredicate {
////        .getByCompositeKey(type_id, game, property, property)
////    }
//    
//    public static func getByProperty(_ type_id: String, _ key: UUID) -> RelationPredicate {
//        #Predicate {
//            $0.type_id                  == type_id
//            && $0.property_key_uuid     == key
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
