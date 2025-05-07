//
//  ContentView.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            GamesListView()
            .toolbar {
                
//                ToolbarItem(placement: .topBarTrailing, content: {
//                    
//                    Button("Add") {
//                        let snapshot: GameSnapshot = .random
//                        self.modelContext.save(snapshot)
//                    }
//                    
//                })
                
            }
        }
        
    }
    
}

#Preview {
    
//    let previewModelContainer: ModelContainer = {
//        
//        let container: ModelContainer = .preview
//        
//        container.mainContext.autosaveEnabled = false
//        container.mainContext.undoManager = .init()
//            
//        return container
//
//    }()
//
//    return
    
    ContentView()
        .modelContainer(.preview)
//        .environmentObject(Configuration.defaultValue)
}

