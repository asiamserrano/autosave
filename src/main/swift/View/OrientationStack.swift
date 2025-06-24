//
//  OrientationStack.swift
//  autosave
//
//  Created by Asia Serrano on 6/15/25.
//

import SwiftUI

struct OrientationStack<T: View>: View {
    
    enum OrientationEnum {
        case vstack, hstack
    }
    
    typealias Content = () -> T
    
    let content: Content
    let orientation: OrientationEnum
    
    init(_ orientation: OrientationEnum, @ViewBuilder _ content: @escaping Content) {
        self.orientation = orientation
        self.content = content
    }
    
    var body: some View {
        switch orientation {
        case .vstack:
            VStack(alignment: .leading) {
                self.content()
            }
        case .hstack:
            HStack(alignment: .center) {
                self.content()
            }
        }
    }
    
}
