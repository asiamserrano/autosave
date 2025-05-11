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
    
    let status: GameStatusEnum
    
    public init(_ status: GameStatusEnum) {
        self.status = status
    }
    
    var body: some View {
        ModelsView(models, "no games", content: {
            SearchView(status, search)
        })
        .searchable(text: $search)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: {
                    GameForm(self.status)
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
    
    init(_ status: GameStatusEnum, _ search: String) {
        let bool: Bool = status.bool
        let canon = search.canonicalized
        self._models = .init(filter: .getForList(bool, canon), sort: .defaultValue(.defaultValue))
    }
    
    var body: some View {
        ModelsView(models, "no results", content: {
            Form {
                ForEach(models) { model in
                    NavigationLink(destination: {
                        let builder: GameBuilder = .init(model)
                        GameView(builder)
                    }, label: {
                        let snapshot: GameSnapshot = model.snapshot
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
