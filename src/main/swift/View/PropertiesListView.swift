//
//  PropertiesListView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI
import SwiftData

// TODO: structure needs to completely change. simplified platform will not allow for distinct querying
struct PropertiesListView: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @Query var models: [PropertyModel]
    
    var body: some View {
        ModelsView(models, "no properties", content: {
            Form {
                Section {
                    ForEach(InputEnum.cases) { input in
                        FilteredView(input)
                    }
                }
                FilteredView(.mode)
                
                Section("Formats") {
                    ForEach(FormatEnum.cases) { format in
                        FilteredView(.platform, format)
                    }
                }
                
            }
        })
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

    
//    @ViewBuilder
//    func BuilderView(_ model: PropertyModel) -> some View {
//        let snapshot: PropertySnapshot = .fromModel(model)
//        let builder: PropertyBuilder = .fromSnapshot(snapshot)
//        switch builder {
//        case .input(let builder):
//            HStack {
//                Text(builder.type.rawValue)
//                Spacer()
//                Text(builder.string.trimmed)
//            }
//        case .mode(let modeEnum):
//            HStack {
//                Text(modeEnum.propertyEnum.rawValue)
//                Spacer()
//                Text(modeEnum.rawValue)
//            }
//        case .platform(let builder):
//            HStack {
//                Text(builder.system.rawValue)
//                Spacer()
//                Text(builder.format.rawValue)
//            }
//        }
//    }
    
}

fileprivate struct FilteredView: View {
    
    public enum FilterEnum: Enumerable {
        case series
        case developer
        case publisher
        case genre
        case mode
        case system
        case format
    }
    
    @Query var models: [PropertyModel]
    
    let type: FilterEnum
    let title: String
    
    init(_ type: InputEnum) {
        let property: PropertyEnum = .init(type)
        self.init(property)
    }
    
    init(_ type: PropertyEnum) {
        self.type = .init(type)
        self.title = type.rawValue.pluralize()
        self._models = .init(filter: .getByType(type.id), sort: .defaultValue)
    }
    
    init(_ type: PropertyEnum, _ format: FormatEnum) {
        self.type = .format
        self.title = format.rawValue
        let type_id: String = type.id
        let format_id: String = format.id
        
        var descriptor: PropertyFetchDescriptor =
            .init(predicate: #Predicate {
                $0.type_id == type_id && $0.value_trim.starts(with: format_id)
            },
                  sortBy: .defaultValue)
        
        descriptor.fetchLimit = 1
        
        
        
        self._models = .init(filter: #Predicate {
            $0.type_id == type_id && $0.value_trim.starts(with: format_id)
        }, sort: .defaultValue)
    }
    
//    var title: String {
//        self.type.rawValue.pluralize()
//    }
    
    var body: some View {
        ModelsView(models, content: {
            switch type {
            case .series, .developer, .publisher, .genre:
                NavigationLink(destination: {
                    Form(content: ForEachView)
                    .navigationTitle(title)
                }, label: {
                    Text(title)
                })
            case .mode:
                Section(title, content: ForEachView)
            case .format:
                NavigationLink(destination: {
                    Form(content: {
                        ForEach(models) { model in
                            let builder: FormatBuilder = .init(model.value_trim)
                            Text(builder.rawValue)
                        }
                    })
                    .navigationTitle("\(title) Formats")
                }, label: {
                    Text(title)
                })
            default:
                EmptyView()
            }
        })
    }
    
    @ViewBuilder
    private func ForEachView() -> some View {
        ForEach(models) { model in
            Text(model.value_trim)
        }
    }
    
}
