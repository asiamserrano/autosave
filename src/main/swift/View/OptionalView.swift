//
//  OptionalView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI
import SwiftData

struct OptionalView<T: View>: View {
    
    typealias ViewFunc = () -> T
    
//    let count: Int
    let isShowing: Bool
    let message: String?
    let content: ViewFunc
    
    init(_ collection: any Collection, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        let isShowing: Bool = collection.isNotEmpty
        self.init(isShowing, message, content: content)
    }

//    init(_ count: Int, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
//        self.isShowing = count > 0
//        self.message = message
//        self.content = content
//    }
    
    init(_ isShowing: Bool, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        self.isShowing = isShowing
        self.message = message
        self.content = content
    }
    
    var body: some View {
        if isShowing {
           content()
        } else {
            if let message: String = self.message {
                VStack {
                    Text(message)
                }
            }
        }
    }
    
}

struct OptionalArrayView<Element: Any, T: View>: View {
    
    enum ContentEnum {
        case element(ElementContent)
        case elements(ElementsContent)
        case wrapper(WrapperContent)
    }
        
    typealias Elements = [Element]
    
    typealias ElementContent = (Element) -> T
    typealias ElementsContent = (Elements) -> T
    typealias WrapperContent = () -> T
    
    let elements: [Element]
    let content: ContentEnum
    
//    init(_ elements: Elements, _ content: ContentEnum) {
//        self.elements = elements
//        self.content = content
//    }
    
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
        if count > 0 {
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
        }
    }
    
}
