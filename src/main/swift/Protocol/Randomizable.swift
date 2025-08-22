//
//  Randomizable.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import Foundation

public protocol Randomizable {
    static var random: Self { get }
}
