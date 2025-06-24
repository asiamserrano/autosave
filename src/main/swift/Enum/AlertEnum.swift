//
//  AlertEnum.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation

public enum AlertEnum: Hashable, Equatable {
        
    case none
    case test
    case add_game(GameResult)
    case edit_game(GameResult)
    case delete_game(GameModel)
    case move_game(GameModel, GameStatusEnum)
//    case delete_tag(TagModel)
//    case edit_tag(TagResult)
    
//    public var title: String {
//        switch self {
//        case .none: return .defaultValue
//        case .test: return "Test Alert"
//        case .add_game(let game): return game.title
//        case .edit_game(let game): return game.title
//        case .delete_game: return "Delete Game"
//        case .move_game: return "Move Game"
////        case .delete_tag: return "Delete Property"
////        case .edit_tag(let result): return result.title
//        }
//    }
//    
//    public var message: String {
//        switch self {
//        case .none: return .defaultValue
//        case .test: return "This is a test alert"
//        case .add_game(let game): return game.message
//        case .edit_game(let game): return game.message
//        case .delete_game(let game):
//            let display: String = game.snapshot.display
//            return "Are you sure you want to delete \(display)?"
//        case .move_game(let game, let status):
//            let display: String = game.snapshot.display
//            let value: String = status.display.lowercased()
//            return "Are you sure you want to move \(display) to your \(value)?"
////        case .delete_tag(let tag):
////            return "Are you sure you want to delete \(tag.builder.value)?"
////        case .edit_tag(let result):
////            return result.message
//        }
//    }
//    
//    public var color: Color {
//        switch self {
//        case .delete_game(_): return .red
//        case .move_game(_,_): return .green
//        default: return .accentColor
//        }
//    }
//    
}
