//
//  QuantifiableView.swift
//  autosave
//
//  Created by Asia Serrano on 8/9/25.
//

import SwiftUI

struct QuantifiableView<Element: Quantifiable, T: View>: View {
    
    typealias Content = (Element) -> T
    
    private let element: Element?
    private let content: Content
    
    init(_ element: Element?, @ViewBuilder content: @escaping Content) {
        self.element = element
        self.content = content
    }

    var body: some View {
        if let element: Element = element {
            content(element)
                .show(element.isOccupied)
        }
    }
    
}
