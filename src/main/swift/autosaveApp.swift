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


//extension PropertySnapshot {
//    
//    public var isNotFormat: Bool {
//        switch self.base {
//        case .platform(let platform):
//            switch platform {
//            case .system: return true
//            case .format: return false
//            }
//        default: return true
//        }
//    }
//    
//    public var isNotMode: Bool {
//        switch self.base {
//        case .mode: return false
//        default: return true
//        }
//    }
//    
//    public var isNotInput: Bool {
//        switch self.base {
//        case .input: return false
//        default: return true
//        }
//    }
//    
//    public var isDefault: Bool { true }
//    
//}

#Preview {
    
    let games_max: Int = 20
    let properties_max: Int = 50
    
    let previewModelContainer: ModelContainer = {
        
        let container: ModelContainer = .preview
        
        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
        
//        var properties_count: Int = 0
        
        var games: [GameModel] = .defaultValue
        var properties: [PropertyModel] = .defaultValue
        
        while games.count < games_max {
            if let model: GameModel = container.mainContext.save(.random) {
                games.append(model)
            }
        }
            
        while properties.count < properties_max {
            if let model: PropertyModel = container.mainContext.save(.random) {
                properties.append(model)
            }
        }
                
//        // TODO: update this to create properties and/or games via relation instead
//        while properties_count < properties_max {
//            let random: RelationBuilder = .random
//            for _ in 0..<Int.random(in: 1...5) {
//                let game: GameModel = games.randomElement
//                properties_count += container.mainContext.save(game, random)
//            }
//        }
        
        return container
        
    }()
    
    return ContentView()
        .modelContainer(previewModelContainer)
}
