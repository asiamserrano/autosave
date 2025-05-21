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
                        let predicate: PropertyPredicate = .getByType(input.id)
                        if modelContext.fetchCount(predicate).isGreaterThanZero {
                            InputView(input)
                        }
                    }
                }
                
//                ModeView()
                
                PropertyView(.mode)
                                
                ForEach(PlatformEnum.cases) { platform in
                    let predicate: PropertyPredicate = .getByType(platform.prefix_id)
                    if modelContext.fetchCount(predicate).isGreaterThanZero {
//                        PlatformView(platform)
                        let title: String = platform.rawValue.pluralize()
                        let cases: PlatformBase.Cases = PlatformBase.cases.filter { $0.platformEnum == platform }
                        Section(title) {
                            ForEach(cases) { base in
                                PropertyView(.platform(base))
                            }
                        }
                    }
                }
                
            }
        })
    }

}

//fileprivate struct ModeView: PropertyViewable {
//    
//    let predicate: PropertyPredicate
//    let title: String
//    
//    init() {
//        let base: PropertyBase = .mode
//        self.title = base.rawValue.pluralize()
//        self.predicate = .getByType(base.id)
//    }
//    
//    var body: some View {
//        PropertyModelsView(predicate, content: { models in
//            Section(title, content: {
//                ForEachView(models)
//            })
//        })
//    }
//    
//}

//fileprivate struct PlatformView: PropertyViewable {
//    
//    let cases: PlatformBase.Cases
//    let title: String
//    
//    init(_ platform: PlatformEnum) {
//        self.title = platform.rawValue.pluralize()
//        self.cases = PlatformBase.filter(platform)
//    }
//    
//    var body: some View {
//        Section(title) {
//            ForEach(cases) { base in
//                PropertyView(.platform(base))
//            }
//        }
//    }
//
//}

fileprivate struct PropertyView: View {
    
    let base: PropertyBase
    let predicate: PropertyPredicate
    let title: String
    let message: String?
    
    init(_ base: PropertyBase, _ predicate: PropertyPredicate? = nil, _ message: String? = nil) {
        self.base = base
        self.title = base.rawValue.pluralize()
        self.predicate = predicate ?? .getByType(base.id)
        self.message = message
    }
    
    var body: some View {
        PropertyModelsView(predicate, message, content: { models in
            switch base {
            case .mode:
                Section(title, content: {
                    ForEachView(models)
                })
            case .input:
                FormForEachView(models, title)
            case .platform(let platformBase):
                let navigation_title: String = platformBase.navigationTitle
                NavigationLink(destination: {
                    FormForEachView(models, navigation_title)
                }, label: {
                    Text(platformBase.rawValue)
                })
            }
            
        })
    }
    
    @ViewBuilder
    func ForEachView(_ models: Models) -> some View {
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
    func FormForEachView(_ models: Models, _ title: String) -> some View {
        Form(content: {
            ForEachView(models)
        })
        .navigationTitle(title)
    }
    
}

//fileprivate protocol PropertyViewable: View {}
//
//fileprivate extension PropertyViewable {
//    
////    @ViewBuilder
////    func ForEachView(_ models: Models) -> some View {
////        ForEach(models) { model in
////            NavigationLink(destination: {
////                Text("TBD")
////                .navigationTitle("Games")
////            }, label: {
////                Text(model.value_trim)
////            })
////        }
////    }
////    
////    @ViewBuilder
////    func FormForEachView(_ models: Models, _ title: String) -> some View {
////        Form(content: {
////            ForEachView(models)
////        })
////        .navigationTitle(title)
////    }
////    
//}

fileprivate typealias Models = [PropertyModel]

fileprivate struct PropertyModelsView<T: View>: View {
        
    @Query var models: Models
    
    typealias ViewFunc = (Models) -> T
    
    let content: ViewFunc
    let message: String?
    
    init(_ predicate: PropertyPredicate, _ message: String? = nil, @ViewBuilder content: @escaping ViewFunc) {
        self.content = content
        self.message = message
        self._models = .init(filter: predicate, sort: .defaultValue)
    }
    
    var body: some View {
        ModelsView(models, message, content: {
            content(models)
        })
    }
    
}

fileprivate struct InputView: View {
        
    @State var search: String = .defaultValue
    
    let base: PropertyBase
    let input: InputEnum
    let title: String
    let message: String
    
    public init(_ input: InputEnum) {
        let title: String = input.rawValue.pluralize()
        self.base = .input(input)
        self.input = input
        self.title = title
        self.message = "no \(title.lowercased())"
    }
    
    var body: some View {
        NavigationLink(destination: {
            let predicate: PropertyPredicate = .getByType(input.id, search.canonicalized)
            PropertyView(base, predicate, message)
            .searchable(text: $search)
            .navigationTitle(title)
        }, label: {
            Text(title)
        })
    }
    
}
