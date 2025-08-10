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
    
    init(_ quantifiable: any Quantifiable, @ViewBuilder isOccupied: @escaping True, @ViewBuilder isVacant: @escaping False) {
        self.boolean = quantifiable.isOccupied
        self.trueContent = isOccupied
        self.falseContent = isVacant
    }

    var body: some View {
        self.trueContent()
            .show(self.boolean)
        self.falseContent()
            .hide(self.boolean)
    }
    
}
