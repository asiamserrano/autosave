//
//  SortedSetView.swift
//  autosave
//
//  Created by Asia Serrano on 8/9/25.
//

import SwiftUI
//
//struct SortedSetView<Element: Hashable & Comparable, T: View>: View {
//    
//    typealias Sorted = SortedSet<Element>
//    typealias Content = (Element) -> T
//    
//    let sorted: Sorted
//    let content: Content
//    
//    init(_ sorted: Sorted, @ViewBuilder content: @escaping Content) {
//        self.sorted = sorted
//        self.content = content
//    }
//
//    var body: some View {
//        ForEach(sorted, id:\.self, content: content)
//    }
//    
//}

//struct SortedSetView<S: SortedSetProtocol, T: View>: View {
//        
//    typealias Content = (S.Element) -> T
//    
//    let s: S
//    let content: Content
//    
//    init(_ s: S, @ViewBuilder content: @escaping Content) {
//        self.s = s
//        self.content = content
//    }
//    
//    var body: some View {
//        QuantifiableView(s, content: {
//            ForEach($0, id:\.self, content: content)
//        })
//    }
//    
//}


struct SortedSetView<S: SortedSetProtocol, T: View>: View {
    
    typealias Element = S.Element
    typealias Content = (Element) -> T
    typealias Action = (IndexSet) -> Void
    
    private var s: S
    private let content: Content
    private var onDeleteAction: Action?
    
    init<V: Enumerable>(_ v: V.Type, @ViewBuilder content: @escaping Content) where V == S.Element, S == SortedSet<V> {
        self.s = .init(V.cases)
        self.content = content
    }
    
    init(_ s: S, @ViewBuilder content: @escaping Content) {
        self.s = s
        self.content = content
    }

    var body: some View {
        QuantifiableView(s, content: {
            ForEach($0, id:\.self, content: content)
                .onDelete(perform: onDeleteAction)
        })
    }
    
    func onDelete(action: @escaping Action) -> Self {
        var copy = self
        copy.onDeleteAction = action
        return copy
    }
    
}



//struct DeletableSortedSetView<S: SortedSetProtocol, T: View>: View {
//    
//    typealias Content = (S.Element) -> T
//    
//    @Binding private var s: S
//    private let content: Content
//
//    init(_ s: Binding<S>, @ViewBuilder content: @escaping Content) {
//        self._s = s
//        self.content = content
//    }
//
//    var body: some View {
//        QuantifiableView(s, content: {
//            ForEach($0, id:\.self, content: content)
//                .onDelete(perform: delete)
//        })
//    }
//    
//    private func delete(_ indexSet: IndexSet) -> Void {
//        indexSet.forEach {
//            s -= s[s.index(s.startIndex, offsetBy: $0)]
//        }
//    }
//    
//}
