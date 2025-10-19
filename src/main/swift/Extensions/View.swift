//
//  View.swift
//  autosave
//
//  Created by Asia Serrano on 10/17/25.
//

import SwiftUI

public extension View {
    
    
    @ViewBuilder
    var Icon: some View {
        Image(systemName: "cross")
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15)
            .foregroundColor(.pink)
    }
    
}
