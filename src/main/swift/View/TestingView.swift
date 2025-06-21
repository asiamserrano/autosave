//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

fileprivate enum Foo: Enumerable {
    case category, type, label, none
}

fileprivate enum Bar: Encapsulable {
    
    public static var allCases: Cases {
        Foo.allCases.flatMap { foo in
            switch foo {
            case .category:
                return PropertyCategory.cases.map(Self.category)
            case .type:
                return PropertyType.cases.map(Self.type)
            case .label:
                return PropertyLabel.cases.map(Self.label)
            case .none:
                return Cases.init(Self.none)
            }
        }
    }
    
    case category(PropertyCategory)
    case type(PropertyType)
    case label(PropertyLabel)
    case none
    
    public var enumeror: Enumeror {
        switch self {
        case .category(let category):
            return category
        case .type(let type):
            return type
        case .label(let label):
            return label
        case .none:
            return Foo.none
        }
    }

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

struct TestingView: View {
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(Bar.cases) { bar in
                    Text(bar.id)
                }
            }
        }
    }
    
}

#Preview {
    TestingView()
}
