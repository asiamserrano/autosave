//
//  WrapperView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/7/25.
//

import SwiftUI

struct WrapperView<Element: Any, T: View>: View {
 
    typealias Content = (Element) -> T
    
    let element: Element?
    let content: Content
    
    init(_ element: Element?, @ViewBuilder content: @escaping Content) {
        self.element = element
        self.content = content
    }

    var body: some View {
        if let element: Element = element {
            content(element)
        }
    }
    
}

struct QuantifiableView<Element: Quantifiable, T: View>: View {
 
    typealias Content = (Element) -> T
    
    let element: Element
    let content: Content
    
    init(_ element: Element, @ViewBuilder content: @escaping Content) {
        self.element = element
        self.content = content
    }

    var body: some View {
        if element.isOccupied {
            content(element)
        }
    }
    
}

//struct WrapperSortedSetView<Element: Hashable & Comparable, W: View, E: View>: View {
//    
//    typealias Sorted = SortedSet<Element>
//    typealias WrapperContent = (Sorted) -> W
//    typealias ElementContent = (Element) -> E
//    
//    let sorted: Sorted
//    let wrapper: WrapperContent
//    let element: ElementContent
//    
//    init(_ sorted: Sorted, @ViewBuilder wrapper: @escaping WrapperContent, @ViewBuilder element: @escaping ElementContent) {
//        self.sorted = sorted
//        self.wrapper = wrapper
//        self.element = element
//    }
//
//    var body: some View {
//        QuantifiableView(sorted) { s in
//            wrapper(s) {
//                
//            }
//        }
//    }
//    
//}

struct SortedSetView<Element: Hashable & Comparable, T: View>: View {
    
    typealias Sorted = SortedSet<Element>
    typealias Content = (Element) -> T
    
    let sorted: Sorted
    let content: Content
    
    init(_ sorted: Sorted, @ViewBuilder content: @escaping Content) {
        self.sorted = sorted
        self.content = content
    }

    var body: some View {
        ForEach(sorted, id:\.self, content: content)
    }
    
}
