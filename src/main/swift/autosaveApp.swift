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
        .environmentObject(Configuration.defaultValue)
        
    }
    
}

fileprivate struct ContentView: Configurable {
    
    @EnvironmentObject var configuration: Configuration
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Group {
                switch self.menu {
                case .game(let status):
                    GamesListView(status)
                case .properties:
                    PropertiesListView()
                }
            }
            .navigationTitle(self.menu.rawValue)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading, content: {
                    Menu(content: {
                        Picker(.defaultValue, selection: configuration.menuBinding, content: {
                            ForEach(MenuEnum.cases) { menu in
                                HStack {
                                    Text(menu.rawValue)
                                    Image(menu.icon)
                                }
                                .tag(menu)
                            }
                        }).pickerStyle(.automatic)
                    }, label: {
                        IconView(.line_3_horizontal)
                    })
                })
                
            }
        }
        
    }
    
}

#Preview {
    
    let games_max: Int = 20
    
    let previewModelContainer: ModelContainer = {
        
        let container: ModelContainer = .preview
        
        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
                
        var isLibraryEmpty: Bool = true
        
        while container.mainContext.fetchCount(.game) < games_max || isLibraryEmpty {
            if let model: GameModel = container.mainContext.save(.random) {
                if model.status_bool {
                    isLibraryEmpty = false
                    let tags: Tags = .random
                    tags.builders.forEach { builder in
                        container.mainContext.save(model, builder)
                    }
                }
            }
        }
        
        return container
        
    }()
    
    return ContentView()
        .modelContainer(previewModelContainer)
        .environmentObject(Configuration.defaultValue)
}
