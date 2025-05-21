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
    }
    
    @ViewBuilder
    func TempView() -> some View {
        Form {
            Section {
                ForEach(models) { model in
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
                        PropertyView(.input(input))
                    }
                }
                
                PropertyView(.mode)
                                
                ForEach(PlatformEnum.cases) { platform in
                    PlatformView(platform)
                }
                
            }
        })
    }

}

fileprivate struct PlatformView: View {
    
    @Query var models: [PropertyModel]
    
    let cases: PlatformBase.Cases
    let title: String
    
    init(_ platform: PlatformEnum) {
        self.cases = PlatformBase.filter(platform)
        self.title = platform.rawValue.pluralize()
        self._models = .init(filter: .getByType(platform.prefix_id), sort: .defaultValue)
    }
    
    var body: some View {
        ModelsView(models, content: {
            Section(title) {
                ForEach(cases) { base in
                    let navigation_title: String = base.createTitle(title)
                    PropertyView(base, navigation_title)
                }
            }
        })
    }

}

fileprivate struct PropertyView: View {
    
    @Query var models: [PropertyModel]
    
    let base: PropertyBase
    let title: String
    let text: String
    
    public init(_ platform: PlatformBase, _ title: String) {
        let base: PropertyBase = .platform(platform)
        let text: String = base.rawValue
        self._models = .init(filter: .getByType(base.id), sort: .defaultValue)
        self.base = base
        self.title = title
        self.text = text
    }
    
    public init(_ base: PropertyBase) {
        let string: String = base.rawValue.pluralize()
        self._models = .init(filter: .getByType(base.id), sort: .defaultValue)
        self.base = base
        self.title = string
        self.text = string
    }
        
    var body: some View {
        ModelsView(models, content: {
            switch base {
            case .mode:
                Section(text, content: ForEachView)
            default:
                NavigationLink(destination: {
                    Form(content: ForEachView)
                    .navigationTitle(title)
                }, label: {
                    Text(text)
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
