//
//  ButtonSection.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import SwiftUI

struct ButtonSection<Content: View, Destination: View>: View {
    
    typealias ContentFunc = () -> Content
    typealias DestinationFunc = () -> Destination
    
    let content: () -> Content
    let destination: () -> Destination
    let text: String
    
    init(_ text: String, @ViewBuilder content: @escaping ContentFunc, @ViewBuilder destination: @escaping DestinationFunc) {
        self.content = content
        self.destination = destination
        self.text = text
    }
    
    var body: some View {
//        NavigationStack {
            Section(content: {
                self.content()
            }, header: {
                
                NavigationLink(destination: self.destination, label: {
                    HStack(alignment: .center, spacing: 17) {
                        IconView(.plus_circle_fill, 22, 22, .green)
                        Text(self.text)
                    }
                    .padding(.leading, 1)
                })
                .padding(.bottom, 8)
                
                
                
//                Button(action: self.action, label: {
//                    HStack(alignment: .center, spacing: 17) {
//                        IconView(.plus_circle_fill, 22, 22, .green)
//                        Text(self.text)
//                    }
//                    .padding(.leading, 1)
//                })
//                .padding(.bottom, 8)
//                .disabled(self.disabled)
            })
            .textCase(nil)
//        }
    }
    
    
    
}
