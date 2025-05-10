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
    @State var menu: MenuEnum = .defaultValue
    
    var body: some View {
        NavigationStack {
            Group {
                switch self.menu {
                case .library, .wishlist:
                    GamesListView(self.status)
                case .properties:
                    Text("TBD")
                }
            }
            .navigationTitle(self.menu.rawValue)
            .onChange(of: self.menu) {
                switch self.menu {
                case .library, .wishlist:
                    let id: String = self.menu.id
                    self.status = .init(id)
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


#Preview {
    
    let previewModelContainer: ModelContainer = {
        
        let container: ModelContainer = .preview
        
        container.mainContext.autosaveEnabled = false
        container.mainContext.undoManager = .init()
        
        for _ in 0..<20 {
            let snapshot: GameSnapshot = .random
            container.mainContext.save(snapshot)
        }
        
        return container
        
    }()
    
    return ContentView()
        .modelContainer(previewModelContainer)
}
