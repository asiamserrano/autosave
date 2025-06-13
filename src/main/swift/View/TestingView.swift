//
//  TestingView.swift
//  autosave
//
//  Created by Asia Serrano on 5/18/25.
//

import SwiftUI

struct TestingView: View {
    
    @State var uuid: UUID = .init()

    var body: some View {
        NavigationStack {
            Form {
                ForEach(PropertyLabel.cases) { label in
                                        
                    DisclosureGroup(content: {
                        let builder: PropertyBuilder = .random(label)
                        LeadingVStack {
                            
                            /*
                             example: selected format digital psn
                             
                             1. What type of property is PSN?
                                - format
                             
                             2. What type of property is format?
                                - selected
                             
                             3. What type of format is PSN?
                                - digital
                             
                             
                             | type     | label     | ???       | value
                             selected   format      digital     psn
                             selected   mode        mode        single
                             input      series      series      gta
                             input      genre       genre       action-adventure
                             selected   system      os          macOS
                             
                             selected ->
                             input -> genre -> genre | action-adventure
                             
                             
                             */
                            //
                            
                            FormattedView("Category", builder.category.rawValue)
                            FormattedView("Type", builder.type.rawValue)
                            FormattedView("Label", builder.label.rawValue)
                            FormattedView("Entry", builder.entry)
                        }
                    }, label: {
                        Text(label.rawValue)
                    })
                    
                }
            }
            .id(uuid)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reload") {
                        self.uuid = .init()
                    }
                }
            }
        }
    }
    
//    @ViewBuilder
//    private func SpacedView(_ key: String, _ value: String) -> some View {
//        HStack {
//            SpacedTextView(key, .leading, .gray)
//            Spacer()
//            SpacedTextView(value, .trailing, .black)
//        }
//    }
//    
//    @ViewBuilder
//    private func SpacedTextView(_ text: String, _ alignment: TextAlignment, _ color: Color) -> some View {
//        Text(text)
//            .multilineTextAlignment(alignment)
//            .foregroundColor(color)
//    }
    
//
//    private func getBuilderValue(_ builder: NewPropertyEnumBuilder) -> String {
//        switch builder {
//        case .input:
//            return .random
//        case .selected(let selected):
//            
//            var enumeror: Enumeror {
//                switch selected {
//                case .mode:
//                    return ModeEnum.random
//                case .format(let format):
//                    return FormatBuilder.random(format)
//                case .system(let system):
//                    return SystemBuilder.random(system)
//                }
//            }
//            
//            return enumeror.rawValue
//            
//        }
//    }
    
}

#Preview {
    TestingView()
}
