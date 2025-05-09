//
//  autosaveApp.swift
//  autosave
//
//  Created by Asia Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

@main
struct autosaveApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: .defaultValue, inMemory: false, isAutosaveEnabled: false, isUndoEnabled: true)
        
    }
    
}

fileprivate struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext

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
//    }()k
//
//    return
    
    ContentView()
        .modelContainer(.preview)
//        .environmentObject(Configuration.defaultValue)
}


