////
////  SortedMapElementProtocol.swift
////  autosave
////
////  Created by Asia Serrano on 8/10/25.
////
//
//import Foundation
//
//public protocol SortedMapElementProtocol: Identifiable, Hashable {
//    associatedtype K: Enumerable
//    associatedtype V: Hashable & Defaultable
//
//    init(_ key: K, _ value: V)
//    
//    var key: K { get }
//    var value: V { get }
//}
//
//extension SortedMapElementProtocol {
//    
//    public var id: Int {
//        self.hashValue
//    }
//    
//}
