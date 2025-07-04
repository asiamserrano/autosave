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
    
    init(_ boolean: Bool, @ViewBuilder _ trueContent: @escaping True, @ViewBuilder _ falseContent: @escaping False) {
        self.boolean = boolean
        self.trueContent = trueContent
        self.falseContent = falseContent
    }

    var body: some View {
        if boolean {
            trueContent()
        } else {
            falseContent()
        }
    }
}

#Preview {
    BooleanView(false, {
        Text("True View")
    }, {
        Text("False View")
    })
}
