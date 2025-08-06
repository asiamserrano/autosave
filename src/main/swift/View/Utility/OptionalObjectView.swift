//
//  OptionalObjectView.swift
//  autosave
//
//  Created by Asia Serrano on 7/8/25.
//

import SwiftUI

struct OptionalObjectView<Element: Any, T: View>: View {
    
    typealias Content = (Element) -> T
    
    let element: Element?
    let content: Content
    
    init(_ quantifiable: any Quantifiable, @ViewBuilder content: @escaping Content) {
        self.element = quantifiable.isEmpty ? nil : quantifiable as? Element
        self.content = content
    }
    
    init(_ element: Element?, @ViewBuilder content: @escaping Content) {
        self.element = element
        self.content = content
    }

    var body: some View {
        if let element: Element = self.element {
            content(element)
        }
    }
    
}
