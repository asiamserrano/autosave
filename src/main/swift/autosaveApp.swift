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
    
//    func get(_ base: PlatformBase) -> String {
//        "\(base.)"
//    }
    
    let previewModelContainer: ModelContainer = {
        
        let container: ModelContainer = .preview
        
//        container.mainContext.autosaveEnabled = false
//        container.mainContext.undoManager = .init()
        
        for _ in 0..<20 {
            let game: GameSnapshot = .random
            container.mainContext.save(game)
            
        }
        
        for _ in 0..<40 {
            let property: PropertySnapshot = .random
//            container.mainContext.save(property)
            if property.isDefault {
                container.mainContext.save(property)
            }
        }
        
        return container
        
    }()
    
    return ContentView()
        .modelContainer(previewModelContainer)
}
