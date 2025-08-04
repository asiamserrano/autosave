//
//  OptionalDictionaryView.swift
//  autosave
//
//  Created by Asia Serrano on 8/2/25.
//

import SwiftUI

struct OptionalDictionaryView<Element: Any, T: View>: View {
    
    enum ContentEnum {
        case element(ElementContent)
        case elements(ElementsContent)
        case wrapper(WrapperContent)
    }
        
    typealias Elements = [Element]
    
    typealias ElementContent = (Element) -> T
    typealias ElementsContent = (Elements) -> T
    typealias WrapperContent = () -> T
    
    let elements: Elements
    let content: ContentEnum
    
    init(_ elements: Elements, @ViewBuilder _ content: @escaping ElementContent) {
        self.elements = elements
        self.content = .element(content)
    }
    
    init(_ elements: Elements, @ViewBuilder _ content: @escaping ElementsContent) {
        self.elements = elements
        self.content = .elements(content)
    }
    
    init(_ elements: Elements, @ViewBuilder _ content: @escaping WrapperContent) {
        self.elements = elements
        self.content = .wrapper(content)
    }
    
    private var count: Int {
        self.elements.count
    }

    var body: some View {
        OptionalView(count, content: {
            switch content {
            case .element(let content):
                ForEach(0..<count, id:\.self) { (index: Int) in
                    let element: Element = self.elements[index]
                    content(element)
                }
            case .elements(let content):
                content(elements)
            case .wrapper(let content):
                content()
            }
        })
    }
    
}
