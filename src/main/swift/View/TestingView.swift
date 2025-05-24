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
    
    //42B0A2F1-0D33-406D-B947-6D77F945396B
    //184D0A87-55C4-41ED-8F75-D4B36FE3B0C6
    
    var uuid: UUID {
        .init(uuidString: "42B0A2F1-0D33-406D-B947-6D77F945396B")!
    }
    
    var body: some View {
        Form {
            Text(uuid.uuidString)
//            Text(getUUID())
//            CasesView(PlatformBase.cases)
//            CasesView(PropertyBase.cases)
            
        }
    }
    
    func getUUID() -> String {
        let uuid: UUID = .init()
        let string: String = uuid.uuidString
        print(string)
        return string
    }
    
    @ViewBuilder
    func CasesView(_ cases: [Enumeror]) -> some View {
        Section(content: {
            ForEach(cases, id:\.id, content: EnumView)
        })
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
