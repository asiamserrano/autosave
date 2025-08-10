//
//  VisibilityModifier.swift
//  autosave
//
//  Created by Asia Serrano on 8/9/25.
//

import Foundation
import SwiftUI

struct VisibilityModifier: ViewModifier {
    
    var isShowing: Bool

    func body(content: Content) -> some View {
        if isShowing {
            content
        }
    }
    
}

extension View {
    
    func show(_ bool: Bool) -> some View {
        self.modifier(VisibilityModifier(isShowing: bool))
    }
    
    func hide(_ bool: Bool) -> some View {
        self.modifier(VisibilityModifier(isShowing: !bool))
    }
    
}
