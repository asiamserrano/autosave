//
//  ModelsView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI
import SwiftData

struct ModelsView<T: View>: View {
    
    typealias ViewFunc = () -> T
    
    let isShowing: Bool
    let message: String?
    let content: ViewFunc
    
    init(_ models: [Persistor], _ message: String?, @ViewBuilder content: @escaping ViewFunc) {
        self.isShowing = !models.isEmpty
        self.message = message
        self.content = content
    }
    
    init(_ models: [Persistor], @ViewBuilder content: @escaping ViewFunc) {
        self.isShowing = !models.isEmpty
        self.message = nil
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
