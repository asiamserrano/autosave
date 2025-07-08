//
//  OptionalView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI

struct OptionalView<T: View>: View {
    
    typealias ViewFunc = () -> T
    
    let isShowing: Bool
    let message: String?
    let content: ViewFunc
    
    init(_ collection: any Collection, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        let isShowing: Bool = collection.isNotEmpty
        self.init(isShowing, message, content: content)
    }

    init(_ count: Int, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        self.isShowing = count > 0
        self.message = message
        self.content = content
    }
    
    init(_ isShowing: Bool, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        self.isShowing = isShowing
        self.message = message
        self.content = content
    }
    
    var body: some View {
        BooleanView(isShowing, trueView: content, falseView: {
            if let message: String = self.message {
                VStack {
                    Text(message)
                }
            }
        })
    }
    
}
