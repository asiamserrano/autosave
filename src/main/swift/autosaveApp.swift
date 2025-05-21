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
    
    @State var status: GameStatusEnum = .defaultValue
    // TODO: change this once other TODO is completed
    @State var menu: MenuEnum = .properties
    
    var body: some View {
        NavigationStack {
            Group {
                switch self.menu {
                case .library, .wishlist:
                    GamesListView(self.status)
                case .properties:
                    PropertiesListView()
                }
            }
            .navigationTitle(self.menu.rawValue)
            .onChange(of: self.menu) {
                switch self.menu {
                case .library, .wishlist:
                    self.status = .init(self.menu)
                case .properties:
                    break
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading, content: {
                    Menu(content: {
                        Picker(.defaultValue, selection: $menu, content: {
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


extension PropertySnapshot {
    
    public var isNotFormat: Bool {
        switch self.base {
        case .platform(let platform):
            switch platform {
            case .system: return true
            case .format: return false
            }
        default: return true
        }
    }
    
    public var isNotMode: Bool {
        switch self.base {
        case .mode: return false
        default: return true
        }
    }
    
    public var isNotInput: Bool {
        switch self.base {
        case .input: return false
        default: return true
        }
    }
    
    public var isDefault: Bool { true }
    
}

#Preview {
    
    let games_max: Int = 20
    let properties_max: Int = 50
   
    
    let previewModelContainer: ModelContainer = {
        
        let container: ModelContainer = .preview
        
        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
        
        var games_count: Int = 0
        var properties_count: Int = 0
        
        while games_count < games_max {
            let game: GameSnapshot = .random
            if container.mainContext.save(game) {
                games_count = games_count + 1
            }
        }
        
        while properties_count < properties_max {
            let property: PropertySnapshot = .random
            if container.mainContext.save(property) {
                properties_count = properties_count + 1
            }
        }
        
        return container
        
    }()
    
    return ContentView()
        .modelContainer(previewModelContainer)
}
