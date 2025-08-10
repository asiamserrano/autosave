//
//  OptionalView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI

struct OptionalView<Element: Any, T: View>: View {
 
    typealias Content = (Element) -> T
    
    private let element: Element?
    private let content: Content
    
    init(_ element: Element?, @ViewBuilder content: @escaping Content) {
        self.element = element
        self.content = content
    }

    var body: some View {
        if let element: Element {
            content(element)
        }
    }
    
}
