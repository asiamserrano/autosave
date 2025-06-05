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
    
    let count: Int
    let message: String?
    let content: ViewFunc
    
    init(_ models: [Persistor], _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        let count: Int = models.count
        self.init(count, message, content: content)
    }

    init(_ count: Int, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        self.count = count
        self.message = message
        self.content = content
    }
    
    var body: some View {
        if count > 0 {
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

struct LeadingVStack<T: View>: View {
    
    typealias Content = () -> T
    
    let content: Content
    
    init(@ViewBuilder content: @escaping Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            self.content()
        }
    }
    
}
