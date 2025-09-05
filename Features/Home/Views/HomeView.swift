//
//  HomeView.swift
//  autosave
//
//  Created by Asia Serrano on 9/5/25.
//

import SwiftUI
import SwiftData

public struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State var status: GameStatusEnum = .defaultValue
    @State var menu: MenuEnum = .defaultValue
    
    public var body: some View {
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
                        AppIconView(.line_3_horizontal)
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
    
    return HomeView()
        .modelContainer(previewModelContainer)
}

