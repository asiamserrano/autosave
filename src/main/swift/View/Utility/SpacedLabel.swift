//
//  SpacedLabel.swift
//  autosave
//
//  Created by Asia Serrano on 7/15/25.
//

import SwiftUI

public struct SpacedLabel: View {
    
    public enum Emphasis: Enumerable {
        case left, right, regular
    }
    
    let key: String
    let value: String
    let emphasis: Emphasis
    
    public init(_ key: String, _ value: String, _ emphasis: Emphasis) {
        self.key = key
        self.value = value
        self.emphasis = emphasis
    }
    
    public var body: some View {
        HStack {
            KeyView()
            Spacer()
            ValueView()
        }
    }
    
}

private extension SpacedLabel {
    
    struct Info {
        let str: String
        let align: TextAlignment
        
        init(_ str: String, _ align: TextAlignment) {
            self.str = str
            self.align = align
        }
        
    }
    
    @ViewBuilder
    func KeyView() -> some View {
        let info: Info = .init(self.key, .leading)
        switch self.emphasis {
        case .left: StrongView(info)
        case .right: WeakView(info)
        case .regular: RegularView(info)
        }
    }
    
    @ViewBuilder
    func ValueView() -> some View {
        let info: Info = .init(self.value, .trailing)
        switch self.emphasis {
        case .left: WeakView(info)
        case .right: StrongView(info)
        case .regular: RegularView(info)
        }
    }
    
    @ViewBuilder
    func StrongView(_ info: Info) -> some View {
        RegularView(info)
            .foregroundColor(.gray)
            .bold()
    }
    
    @ViewBuilder
    func WeakView(_ info: Info) -> some View {
        RegularView(info)
            .foregroundColor(.gray)
    }
    
    @ViewBuilder
    func RegularView(_ info: Info) -> some View {
        Text(info.str)
            .multilineTextAlignment(info.align)
    }
    
}
