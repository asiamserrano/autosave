//
//  Persistable.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import Foundation
import SwiftData

public typealias Persistor = any Persistable

public protocol Persistable: PersistentModel, Uuidentifiable { }

extension Persistable {
    
    public static var type: Persistor.Type {
        Self.self as! Persistor.Type
    }
    
}
