//
//  EditMode.swift
//  autosave
//
//  Created by Asia Serrano on 6/22/25.
//

import Foundation
import SwiftUI

extension EditMode: Iterable {
    
    public static var cases: [Self] {
        .init(.active, .inactive)
    }
    
}
