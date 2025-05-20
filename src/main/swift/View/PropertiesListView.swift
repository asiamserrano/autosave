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
        
        
        
//        TempView()
        RealView()
        
        
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
    
    @ViewBuilder
    func TempView() -> some View {
        Form {
            
            Section {
                ForEach(PlatformEnum.cases) {
                    Text("\($0.rawValue)Enum")
                }
            }
            
            Section {
                ForEach(models) { model in
    //                let snapshot: PropertySnapshot = model.snapshot
                    Text(model.type_id)
                }
            }
        }
    }
    
    @ViewBuilder
    func RealView() -> some View {
        ModelsView(models, "no properties", content: {
            Form {
                Section {
                    ForEach(InputEnum.cases) { input in
                        FilteredView(.input(input))
                    }
                    
                }
                
                Section("Modes") {
                    FilteredView(.mode)
                }
                
                ForEach(PlatformEnum.cases) { platform in
                    PlatformView(platform)
//                    Section(platform.rawValue) {
//                        ForEach(PlatformBase.filter(platform)) { base in
//                            FilteredView(.platform(base))
//                        }
//                    }
                }
                
            }
        })
    }

}

fileprivate struct PlatformView: View {
    
    @Query var models: [PropertyModel]
    
    let platform: PlatformEnum
    let title: String
    
    init(_ platform: PlatformEnum) {
        self.platform = platform
        self.title = platform.rawValue.pluralize()
        let id: String = "_\(platform.rawValue)Enum"
        self._models = .init(filter: .getByType(id), sort: .defaultValue)
    }
    
    var body: some View {
        ModelsView(models, content: {
            Section(title) {
                ForEach(PlatformBase.filter(platform)) { base in
                    FilteredView(.platform(base))
                }
            }
        })
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
            switch base {
            case .mode:
                ForEachView()
            default:
                NavigationLink(destination: {
                    Form(content: ForEachView)
                    .navigationTitle(title)
                }, label: {
                    Text(title)
                })
            }
        })
    }
    
    @ViewBuilder
    private func ForEachView() -> some View {
        ForEach(models) { model in
            NavigationLink(destination: {
                Text("TBD")
                .navigationTitle("Games")
            }, label: {
                Text(model.value_trim)
            })
        }
    }
    
}
