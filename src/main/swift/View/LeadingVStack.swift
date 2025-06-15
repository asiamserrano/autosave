//
//  LeadingVStack.swift
//  autosave
//
//  Created by Asia Serrano on 6/15/25.
//

import SwiftUI

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
