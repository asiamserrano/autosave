//
//  GamesListView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI
import SwiftData

struct GamesListView: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @Query var models: [GameModel]
    
    @State var search: String = .defaultValue
    
    var body: some View {
        ModelsView(models, "no games", content: {
            SearchView(search)
                .searchable(text: $search)
        })
        .navigationTitle("My Games")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: {
                    // TODO: This is not working
                    GameForm(onSave: { snapshot in
                        self.modelContext.save(snapshot)
                    })
                }, label: {
                    IconView(.plus)
                })
            })
        }
        
    }
    
}

fileprivate struct SearchView: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @Query var models: [GameModel]
    
    init(_ search: String) {
        let canon = search.canonicalized
        self._models = .init(filter: .getBySearch(canon), sort: .defaultValue(.defaultValue))
    }
    
    var body: some View {
        ModelsView(models, "no results", content: {
            Form {
                ForEach(models) { model in
                    let snapshot: GameSnapshot = model.snapshot
                    NavigationLink(destination: {
                        GameView(snapshot)
                    }, label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(snapshot.title)
                                .bold()
                            HStack {
                                HStack(spacing: 8) {
                                    IconView(.calendar, 20, 20)
                                    Text(snapshot.release.dashes)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        }
                    })
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let model: GameModel = self.models[index]
                        self.modelContext.remove(model)
                    }
                })
            }
        })
    }
    
}


fileprivate struct ModelsView<T: View>: View {
    
    typealias ViewFunc = () -> T
    
    let models: [GameModel]
    let message: String
    let content: ViewFunc
    
    init(_ models: [GameModel], _ message: String, @ViewBuilder content: @escaping ViewFunc) {
        self.models = models
        self.message = message
        self.content = content
    }
    
    var body: some View {
        if models.isEmpty {
            VStack {
                Text(message)
            }
        } else {
            content()
        }
    }
    
}
