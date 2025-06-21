//
//  UUID.swift
//  autosave
//
//  Created by Asia Serrano on 6/20/25.
//

import Foundation

extension UUID {
    
    public var short: String {
        let parts: [String] = self.uuidString.components(separatedBy: "-")
        return "\(parts[3])\(parts[4])"
    }
    
}
