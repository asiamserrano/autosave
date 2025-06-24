////
////  GameSort.swift
////  autosave
////
////  Created by Asia Michelle Serrano on 5/7/25.
////
//
//import Foundation
//
//public struct GameSort {
//    let type: TypeEnum
//    let order: SortOrder
//    
//    public init(_ type: TypeEnum, _ order: SortOrder) {
//        self.type = type
//        self.order = order
//    }
//}
//
//public extension GameSort {
//    
//    static var defaultValue: Self {
//        .init(.title, .forward)
//    }
//    
//    func toggle(_ other: Self) -> Self {
//        if self.type == other.type {
//            let t: TypeEnum = self.type
//            let o: SortOrder = self.order.next
//            return .init(t, o)
//        } else {
//            let t: TypeEnum = self.type.next
//            return .init(t, .forward)
//        }
//    }
//    
//    var icon: IconEnum {
//        self.order.icon
//    }
//    
//    var keyPath: KeyPath<GameModel, String> {
//        switch type {
//        case .release:
//            return \.release_date
//        case .title:
//            return \.title_canon
//        }
//    }
//    
//    enum TypeEnum: Enumerable {
//        case release, title
//        
//        public var rawValue: String {
//            switch self {
//            case .release: return "Release Date"
//            case .title: return "Title"
//            }
//        }
//    }
//    
//}
