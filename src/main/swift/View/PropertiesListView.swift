//
//  PropertiesListView.swift
//  autosave
//
//  Created by Asia Serrano on 5/11/25.
//

import SwiftUI
import SwiftData

struct PropertiesListView: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @State var search: String = .defaultValue
    
    var body: some View {
        let count: Int = fetchCount()
        OptionalView(count, "no properties", content: {
            Form {
                ForEach(PropertyEnum.cases) { property in
                    switch property {
                    case .input:
                        Section {
                            ForEach(InputEnum.cases) { input in
                                let count: Int = fetchCount(input.id)
                                OptionalView(count, content: {
                                    let title: String = input.rawValue.pluralize()
                                    NavigationLink(destination: {
                                        let predicate: PropertyPredicate = .getByType(input.id, search.canonicalized)
                                        let base: PropertyBase = .input(input)
                                        PropertyView(base, predicate)
                                            .searchable(text: $search)
                                            .navigationTitle(title)
                                    }, label: {
                                        Text(title)
                                    })
                                })
                            }
                        }
                    case .mode:
                        PropertyView(.mode)
                    case .platform:
                        ForEach(PlatformEnum.cases) { platform in
                            let count: Int = fetchCount(platform.prefix_id)
                            OptionalView(count, content: {
                                let title: String = platform.rawValue.pluralize()
                                let cases: PlatformBase.Cases = PlatformBase.cases.filter { $0.platformEnum == platform }
                                Section(title) {
                                    ForEach(cases) {
                                        let base: PropertyBase = .platform($0)
                                        PropertyView(base)
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    func fetchCount(_ id: String) -> Int {
        let predicate: PropertyPredicate = .getByType(id)
        return fetchCount(predicate)
    }
    
    func fetchCount(_ predicate: PropertyPredicate? = nil) -> Int {
        let desc: PropertyFetchDescriptor = .init(predicate: predicate)
        let int: Int? = try? self.modelContext.fetchCount(desc)
        return int ?? 0
    }
    
}

fileprivate struct PropertyView: View {
    
    @Query var models: [PropertyModel]
    
    let base: PropertyBase
    let title: String
    let message: String?
    
    init(_ base: PropertyBase, _ predicate: PropertyPredicate? = nil) {
        self.base = base
        self.title = base.rawValue.pluralize()
        self.message = predicate == nil ? nil : "no \(title.lowercased())"
        let predicate: PropertyPredicate = predicate ?? .getByType(base.id)
        self._models = .init(filter: predicate, sort: .defaultValue)
    }
    
    var body: some View {
        OptionalView(models, message, content: {
            switch base {
            case .mode:
                Section(title, content: ForEachView)
            case .input:
                FormForEachView(title)
            case .platform(let platformBase):
                let navigation_title: String = platformBase.navigationTitle
                NavigationLink(destination: {
                    FormForEachView(navigation_title)
                }, label: {
                    Text(platformBase.rawValue)
                })
            }
        })
    }
    
    @ViewBuilder
    func ForEachView() -> some View {
        ForEach(models) { model in
            NavigationLink(destination: {
                Text("TBD")
                    .navigationTitle("Games")
            }, label: {
                Text(model.value_trim)
            })
        }
    }
    
    @ViewBuilder
    func FormForEachView(_ title: String) -> some View {
        Form(content: ForEachView)
            .navigationTitle(title)
    }
    
}
