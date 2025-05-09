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
    
}

extension ConstantEnum {
    
    public var rawValue: String {
        self.id.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
}
