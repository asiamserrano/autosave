//
//  UIImage.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import Foundation
import SwiftUI

extension UIImage {
        
    public static func < (lhs: UIImage, rhs: UIImage) -> Bool {
        lhs.id < rhs.id
    }
    
    public var id: String {
        self.data?.description ?? .init()
    }
    
}

public extension UIImage {
    
    static func == (lhs: UIImage, rhs: UIImage) -> Bool {
        lhs.data?.hashValue == rhs.data?.hashValue
    }
    
    var data: Data? {
        self.pngData()
    }
    
    var isEmpty: Bool {
        self.data == nil
    }
    
    convenience init(_ d: Data?) {
        if let data: Data = d {
            self.init(data: data)!
        } else {
            self.init()
        }
    }
    
}
