//
//  PropertiesListView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI
import SwiftData

// TODO: Fix the PlatformBase; system models are showing up in the formats section and vice versa.
// Issue likely in the predicate/fetch descriptor
struct PropertiesListView: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @Query(sort: .defaultValue) var models: [PropertyModel]
    
    var body: some View {
        Form {
            ForEach(models) { model in
                let snapshot: PropertySnapshot = model.snapshot
                FormattedView(snapshot.base.rawValue, snapshot.value_trim)
            }
        }
        
//        ModelsView(models, "no properties", content: {
//            Form {
//                Section {
//                    ForEach(InputEnum.cases) { input in
//                        FilteredView(.input(input))
//                    }
//                    FilteredView(.mode)
//                }
//                
//                ForEach(PlatformEnum.cases) { platform in
//                    Section(platform.rawValue) {
//                        ForEach(PlatformBase.filter(platform)) { base in
//                            FilteredView(.platform(base))
//                        }
//                    }
//                }
//                
//            }
//        })
//        .searchable(text: $search)
        .toolbar {
//            ToolbarItem(placement: .topBarTrailing, content: {
//                NavigationLink(destination: {
//                    GameForm(self.status)
//                }, label: {
//                    IconView(.plus)
//                })
//            })
        }
        
    }

}

fileprivate struct FilteredView: View {
    
    @Query var models: [PropertyModel]
    
    let base: PropertyBase
    let title: String
    
    init(_ base: PropertyBase) {
        self.base = base
        self.title = base.rawValue.pluralize()
        self._models = .init(filter: .getByType(base.id), sort: .defaultValue)
    }
    
    var body: some View {
        ModelsView(models, content: {
            
            NavigationLink(destination: {
                Form(content: ForEachView)
                .navigationTitle(title)
            }, label: {
                Text(title)
            })
        })
    }
    
    @ViewBuilder
    private func ForEachView() -> some View {
        ForEach(models) { model in
            Text(model.value_trim)
        }
    }
    
}
