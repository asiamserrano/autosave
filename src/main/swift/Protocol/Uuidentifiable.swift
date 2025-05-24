//
//  Uuidentifiable.swift
//  autosave
//
//  Created by Asia Serrano on 5/24/25.
//

import Foundation

public typealias Uuidentifor = any Uuidentifiable

public protocol Uuidentifiable {
    var uuid: UUID { get }
}
