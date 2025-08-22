//
//  AnotherTestView.swift
//  autosave
//
//  Created by Asia Serrano on 8/22/25.
//

import SwiftUI

struct AnotherTestView: View {
    
    @State var systemBuilders: SystemBuilders = .random(5..<6)
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(SystemBuilder.cases - systemBuilders.ordered) { systemBuilder in
                    Text(systemBuilder.rawValue)
                }
            }
            .toolbar {
                
//                ToolbarItem {
//                    Button("Delete") {
//                        self.ints = ints - [5, 2, 4]
//                    }
//                }
                
            }
        }
    }
}

#Preview {
    AnotherTestView()
}
