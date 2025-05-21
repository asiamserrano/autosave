//
//  ConstantEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/8/25.
//

import Foundation

public enum ConstantEnum: Enumerable {
    
    case title
    case release_date
    case back
    case cancel
    case confirm
    case ok
    case done
    case delete
    case edit
    case add
    case property
    case properties
    case platform
    case games
    
    public var rawValue: String {
        self.description.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
}
