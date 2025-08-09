//
//  BooleanView.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import SwiftUI

struct BooleanView<TrueContent: View, FalseContent: View>: View {
    
    typealias True = () -> TrueContent
    typealias False = () -> FalseContent
    
    private let boolean: Bool
    private let trueContent: True
    private let falseContent: False
    
    init(_ boolean: Bool, @ViewBuilder trueView: @escaping True, @ViewBuilder falseView: @escaping False) {
        self.boolean = boolean
        self.trueContent = trueView
        self.falseContent = falseView
    }

    var body: some View {
        if boolean {
            trueContent()
        } else {
            falseContent()
        }
    }
}

struct TrueView<T: View>: View {
    
    typealias Content = () -> T
    
    private let boolean: Bool
    private let content: Content
    
    init(_ boolean: Bool, @ViewBuilder _ content: @escaping Content) {
        self.boolean = boolean
        self.content = content
    }
    
    var body: some View {
        if boolean {
            content()
        }
    }
    
}


//#Preview {
//    BooleanView(false, trueView: {
//        Text("True View")
//    }, falseView: {
//        Text("False View")
//    })
//}
