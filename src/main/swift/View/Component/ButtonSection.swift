//
//  ButtonSection.swift
//  autosave
//
//  Created by Asia Serrano on 7/3/25.
//

import SwiftUI

public struct ButtonSection<Content: View>: View {
    
    public typealias Action = () -> Void
    
    let content: Content
    let action: Action
    let text: String
    let disabled: Bool
    
    public init(_ text: String, _ disabled: Bool = false, action: @escaping Action, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.action = action
        self.text = text
        self.disabled = disabled
    }
    
    public var body: some View {
        Section(content: {
            self.content
        }, header: {
            Button(action: self.action, label: {
                HStack(alignment: .center, spacing: 17) {
                    IconView(.plus_circle_fill, 22, 22, .green)
                    Text(self.text)
                }
                .padding(.leading, 1)
            })
            .padding(.bottom, 8)
            .disabled(self.disabled)
        })
        .textCase(nil)
    }
}
