//
//  ModesTestView.swift
//  autosave
//
//  Created by Asia Serrano on 8/15/25.
//

import SwiftUI

struct ModesTestView: View {
    
    @State var modes: Modes = .defaultValue
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(modes) { mode in
                        Text(mode.rawValue)
                    }
                    .onDelete(perform: { indexSet in
                        indexSet.forEach {
                            self.modes -= $0
                        }
                        
                    })
                }
                
                Section {
                    ForEach(modes.builders) { builder in
                        Text(builder.key.builder.value.trim)
                    }
                }
            }
            .toolbar {
                
                ToolbarItem {
                    Button("Add") {
                        self.modes += .random
                    }
                }
                
            }
        }
    }
    
    
}

#Preview {
    ModesTestView()
}
