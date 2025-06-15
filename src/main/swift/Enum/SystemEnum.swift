//
//  SystemEnum.swift
//  autosave
//
//  Created by Asia Serrano on 5/9/25.
//

import Foundation

public enum SystemEnum: Enumerable {
        
    case playstation, nintendo, xbox, os//, mq3
    
    public var rawValue: String {
        switch self {
        case .playstation: return "PlayStation"
        case .nintendo: return "Nintendo"
        case .xbox: return "Xbox"
        case .os: return "Operating System"
//        case .mq3: return "Meta Quest 3"
        }
    }
    
    public var title: String {
        switch self {
        case .os:
            return self.rawValue.pluralize()
        default:
            return "\(self.rawValue) Systems"
        }
    }
    
}
