//
//  Defaultable.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import Foundation

public protocol Defaultable: Equatable {
    
    static var defaultValue: Self { get }
    
}
