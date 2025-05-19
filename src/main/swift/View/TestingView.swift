//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {
    
    @State var set: Set<String> = .init()
    
    private enum EnumEnum: Enumerable {
        case id, description, rawValue, className
    }
    
    var body: some View {
        Form {
            Section(content: {
                ForEach(AttributeEnum.cases, content: EnumView)
            })
        }
    }
    
    @ViewBuilder
    func EnumView(_ enumeror: Enumeror) -> some View {
        VStack(alignment: .leading) {
//            Text(getString(enumeror, .id))
//            Text(getString(enumeror, .description))
            Text(getString(enumeror, .rawValue))
//            Text(getString(enumeror, .className))
        }
    }
    
    private func getString(_ enumeror: Enumeror, _ en: EnumEnum) -> String {
        
        var string: String {
            switch en {
            case .id: return enumeror.id
            case .description: return enumeror.description
            case .rawValue: return enumeror.rawValue
            case .className: return enumeror.className
            }
        }
        
        return string
        
    }
    
    
}

#Preview {
    TestingView()
}
