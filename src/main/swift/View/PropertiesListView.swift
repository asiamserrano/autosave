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
        PropertiesView(.none, $search)
    }
    
}

fileprivate enum PropertyEnum {
    case category(PropertyCategory)
    case type(PropertyType)
    case label(PropertyLabel)
    case none
    
    func predicate(_ search: Binding<String>) -> PropertyPredicate {
        switch self {
        case .category(let category):
            return .getByCategory(category)
        case .type(let type):
            return .getByType(type)
        case .label(let label):
            return .getByLabel(label, search)
        case .none:
            return .true
        }
    }
    
    var message: String? {
        switch self {
        case .none:
            return "no properties"
        case .label(.input):
            return "no results found"
        default:
            return nil
        }
    }
    
}

// TODO: add the delete functionality 
fileprivate struct PropertiesView: View {

    @Environment(\.modelContext) public var modelContext

    @Query var models: [PropertyModel]
    
    @Binding var search: String
    
    let property: PropertyEnum

    init(_ property: PropertyEnum, _ search: Binding<String>) {
        self.property = property
        self._search = search
        let predicate: PropertyPredicate = property.predicate(search)
        self._models = .init(filter: predicate, sort: .defaultValue)
    }
    
    var body: some View {
        switch property {
        case .label(.input):
            PropertyView()
        default:
            OptionalPropertyView(PropertyView)
        }
    }
    
    @ViewBuilder
    func OptionalPropertyView(@ViewBuilder _ content: @escaping () -> some View) -> some View {
        OptionalView(models, property.message, content: content)
    }
    
    @ViewBuilder
    func PropertyView() -> some View {
        switch property {
        case .category(let category):
            PropertyView(category) {
                ForEach(PropertyType.filter(category)) { type in
                    PropertyView(.type(type))
                }
            }
        case .type(let type):
            switch type {
            case .input(let input):
                PropertyView(.label(.input(input)))
            case .selected(let selected):
                
                Section(selected.rawValue.pluralize()) {
                    ForEach(SelectedLabel.filter(selected)) { label in
                        PropertyView(.label(.selected(label)))
                    }
                }
            }
        case .label(let selected):
            switch selected {
            case .input(let input):
                let title: String = input.rawValue.pluralize()
                PropertyNavigationLink(title) {
                    OptionalPropertyView(FormModelsView)
                    .navigationTitle(title)
                    .searchable(text: $search)
                }
            case .selected(let selected):
                switch selected {
                case .mode:
                    ModelsView()
                case .system(let system):
                    PropertyNavigationLink(system.title, system.rawValue)
                case .format(let format):
                    let title: String = format.rawValue
                    let format: String = selected.type.rawValue.pluralize()
                    PropertyNavigationLink("\(title) \(format)", title)
                }
            }
        default:
            Form {
                ForEach(PropertyCategory.cases) { category in
                    PropertyView(.category(category))
                }
            }
            .navigationTitle("Properties")
        }
    }
    
    @ViewBuilder
    func PropertyView(_ category: PropertyCategory, @ViewBuilder _ content: @escaping () -> some View) -> some View {
        switch category {
        case .input:
            Section(content: content)
        case .selected:
            content()
        }
    }
    
    @ViewBuilder
    func PropertyView(_ property: PropertyEnum) -> some View {
        PropertiesView(property, $search)
    }
    
    @ViewBuilder
    func PropertyNavigationLink(_ navigation: String, _ text: String) -> some View {
        PropertyNavigationLink(text) {
            FormModelsView()
                .navigationTitle(navigation)
        }
    }
    
    @ViewBuilder
    func PropertyNavigationLink(_ title: String, @ViewBuilder _ content: @escaping () -> some View) -> some View {
        NavigationLink(destination: content, label: {
            Text(title)
        })
    }
    
    @ViewBuilder
    func FormModelsView() -> some View {
        Form(content: ModelsView)
    }
    
    @ViewBuilder
    func ModelsView() -> some View {
        ForEach(models) { model in
            let label: String = model.value_trim
            NavigationLink(destination: {
                GamesView(model)
                    .navigationTitle("games")
            }, label: {
                Text(label)
            })
        }
    }

}

fileprivate struct GamesView: View {

    @Query var models: [RelationModel]

    init(_ property: PropertyModel) {
        let predicate: RelationPredicate = .getByProperty(property)
        self._models = .init(filter: predicate)
    }

    var body: some View {
        QueryView(models)
    }

    private struct QueryView: View {

        @Query var models: [GameModel]

        init(_ models: [RelationModel]) {
            let predicate: GamePredicate = .getByRelations(models)
            let sort: [GameSortDescriptor] = .defaultValue
            self._models = .init(filter: predicate, sort: sort)
        }

        var body: some View {
            Form {
                ForEach(models) { model in
                    Text(model.title_trim)
                }
            }
        }
        
    }

}
