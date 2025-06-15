//
//  GameResult.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

public struct GameResult: Hashable, Equatable {

    public let snapshot: GameSnapshot
    public let successful: Bool
    public let type: ResultEnum
    
    public init(_ snapshot: GameSnapshot, _ inserted: Bool, _ type: ResultEnum) {
        self.snapshot = snapshot
        self.successful = inserted
        self.type = type
    }
    
}

//public struct PropertyResult: Hashable, Equatable {
//
//    public let snapshot: PropertySnapshot
//    public let successful: Bool
//    public let type: ResultEnum
//    
//    public init(_ snapshot: PropertySnapshot, _ inserted: Bool, _ type: ResultEnum) {
//        self.snapshot = snapshot
//        self.successful = inserted
//        self.type = type
//    }
//    
//}

public enum ResultEnum: Enumerable {
    case add, edit
}


//
//public enum ResultBase {
//    case game(GameSnapshot)
//    case property(PropertySnapshot)
//}
//
//public struct ResultBuilder {
//    let successful: Bool
//    let type: ResultEnum
//    
//    public init(_ successful: Bool, _ type: ResultEnum) {
//        self.successful = successful
//        self.type = type
//    }
//}
//
//public struct ResultSnapshot {
//    let base: ResultBase
//    let builder: ResultBuilder
//    
//    public init(_ model: PropertyModel, _ inserted: Bool, _ type: ResultEnum) {
//        self.base = .property(model.snapshot)
//        self.builder = .init(inserted, type)
//    }
//    
//}




//public extension GameResult {
//        
//
//    
////    var alert: AlertEnum {
////        switch self.enumeration {
////        case .add: return .add_game(self)
////        case .edit: return .edit_game(self)
////        }
////    }
//    
////    var title: String {
////        switch self.enumeration {
////        case .add: return successful ? "Created Game" : "Failed to Create Game"
////        case .edit: return successful ? "Updated Game" : "Failed to Update Game"
////        }
////    }
////    
////    var message: String {
////        switch self.enumeration {
////        case .add:
////            let result: String = successful ? "created" : "create"
////            return message(result)
////        case .edit:
////            let result: String = successful ? "updated" : "update"
////            return message(result)
////        }
////    }
////    
//}
//
//public extension GameResult? {
//    
////    var alert: AlertEnum {
////        if let result = self {
////            switch result.enumeration {
////            case .add: return .add_game(result)
////            case .edit: return .edit_game(result)
////            }
////        } else {
////            return .none
////        }
////    }
//    
//}
//
//private extension GameResult {
//    
////    func message(_ result: String) -> String {
////        let display: String = snapshot.display
////        if successful {
////            return "\(display) has been successfully \(result)!"
////        } else {
////            let location: String = snapshot.status.display
////            return "Unable to \(result) game. \(display) already exists in your \(location)."
////        }
////    }
//    
//}
