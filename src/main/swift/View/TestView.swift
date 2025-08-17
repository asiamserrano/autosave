//
//  TestView.swift
//  autosave
//
//  Created by Asia Serrano on 8/13/25.
//

import SwiftUI

extension Platforms {

    static var random: Self {
        var new: Self = .init()
        SystemEnum.cases.forEach {
            new[$0] = .random($0)
        }
        return new
    }

}

extension Systems {

    static func random(_ system: SystemEnum) -> Self {
        var new: Self = .init()
        SystemBuilder.cases.filter { $0.type == system}.forEach {
            if Bool.random() { new[$0] = .random($0) }
        }
        return new
    }

}

extension Formats {

    static func random(_ builder: SystemBuilder) -> Self {
        var new: Self = .init()

        let builders: [FormatBuilder] = builder.formatBuilders
        builders.forEach { new += $0 }

        if new.count == 0 { new += builders.randomElement }

        return new
    }

}

struct TestView: View {
    
    @State var platforms: Platforms

    init() { self._platforms = .init(wrappedValue: .random) }

    var body: some View {
        NavigationStack {
            Form {
                SortedSetView(self.platforms.keys) { systemEnum in
                    OptionalView(self.platforms[systemEnum], content: { systems in
                        SystemsView(systemEnum, systems)
                    })
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        self.platforms += .random
                    }, label: {
                        Text("Add")
                    })
                })
            }
        }
    }
    
    @ViewBuilder
    private func SystemsView(_ systemEnum: SystemEnum, _ systems: Systems) -> some View {
        QuantifiableView(systems.keys) { systemBuilders in
            SortedSetView(systemBuilders) { systemBuilder in
                DisclosureGroup(content: {
                    OptionalView(systems[systemBuilder]) { formats in
                        FormatEnumsView(systemEnum, systemBuilder, formats)
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 10) {
                        Text(systemBuilder.rawValue)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                })
            }
            .onDelete(action: {
                $0.forEach { index in
                    self.set(self.platforms --> (systemEnum, systems --> (systemBuilders[index], nil)))
                }
            })
        }
    }
    
    @ViewBuilder
    private func FormatEnumsView(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder, _ formats: Formats) -> some View {
        QuantifiableView(formats.keys) { formatEnums in
            SortedSetView(formatEnums) { formatEnum in
                FormatBuildersView(systemEnum, systemBuilder, formats, formatEnum)
            }
            .onDelete(action: {
                $0.forEach { index in
                    self.set(self.platforms --> (systemEnum, self.platforms.get(systemEnum) --> (systemBuilder, formats - formatEnums[index])))
                }
            })
        }
    }
    
    @ViewBuilder
    private func FormatBuildersView(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder, _ formats: Formats, _ formatEnum: FormatEnum) -> some View {
        QuantifiableView(formats.get(formatEnum)) { formatBuilders in
            DisclosureGroup(content: {
                SortedSetView(formatBuilders) { formatBuilder in
                    HStack(spacing: 15) {
                        IconView(.arrow_right, .blue)
                        Text(formatBuilder.rawValue)
                    }
                }
                .onDelete(action: {
                    $0.forEach { index in
                        self.set(self.platforms --> (systemEnum, self.platforms.get(systemEnum) --> (systemBuilder, formats - formatBuilders[index])))
                    }
                })
            }, label: {
                HStack {
                    IconView(formatEnum.icon, .blue)
                    Text(formatEnum.rawValue)
                }
            })
        }
    }
    
    private func set(_ new: Platforms) -> Void {
        self.platforms = new
    }
}

#Preview {
    TestView()
}

/*
 struct TestView: View {
     
     @State var platforms: Platforms

     init() {
         
         self._platforms = .init(wrappedValue: .random)
     }

     var body: some View {
         NavigationStack {
             Form {
                 SystemEnumsView(self.platforms.keys.sorted())
             }
             .toolbar {
                 ToolbarItem(placement: .topBarTrailing, content: {
                     Button(action: {
                         self.platforms += .random
                     }, label: {
                         Text("Add")
                     })
                 })
             }
         }
     }
     
     @ViewBuilder
     private func CenterDisclosureGroup(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder, _ formatEnum: FormatEnum, _ formatBuilders: FormatBuilders) -> some View {
         DisclosureGroup(content: {
             SortedSetView(formatBuilders) { formatBuilder in
                 HStack(spacing: 15) {
                     IconView(.arrow_right, .blue)
                     Text(formatBuilder.rawValue)
                 }
             }
             .onDelete(action: {
                 $0.forEach { index in
                     
                     let new: FormatBuilders = formatBuilders - formatBuilders[index]
                     
                     var systems: Systems = self.platforms[systemEnum] ?? .defaultValue
                     var formats: Formats = systems[systemBuilder] ?? .defaultValue
                     
                     formats[formatEnum] = new.isEmpty ? nil : new
                     systems[systemBuilder] = formats.isEmpty ? nil : formats
                     self.platforms[systemEnum] = systems.isEmpty ? nil : systems
                 }
             })
         }, label: {
             HStack {
                 IconView(formatEnum.icon, .blue)
                 Text(formatEnum.rawValue)
             }
         })
     }
     
     @ViewBuilder
     private func FormatEnumsView(_ systemEnum: SystemEnum, _ systemBuilder: SystemBuilder, _ formatEnums: [FormatEnum]) -> some View {
         ForEach(formatEnums, id:\.self) { formatEnum in
             OptionalView(self.platforms[systemEnum], content: { systems in
                 OptionalView(systems[systemBuilder], content: { formats in
                     OptionalView(formats[formatEnum], content: {
                         CenterDisclosureGroup(systemEnum, systemBuilder, formatEnum, $0)
                     })
                 })
             })
         }
         .onDelete(perform: {
             $0.forEach { index in
                 var systems: Systems = self.platforms[systemEnum] ?? .defaultValue
                 var formats: Formats = systems[systemBuilder] ?? .defaultValue
                 
                 formats[formatEnums[index]] = nil
                 systems[systemBuilder] = formats.isEmpty ? nil : formats
                 self.platforms[systemEnum] = systems.isEmpty ? nil : systems
             }
         })
     }
     
     @ViewBuilder
     private func TopDisclosureGroup(_ systemEnum: SystemEnum, _ systemBuilders: [SystemBuilder]) -> some View {
         ForEach(systemBuilders, id:\.self) { systemBuilder in
             DisclosureGroup(content: {
                 OptionalView(self.platforms[systemEnum], content: { systems in
                     OptionalView(systems[systemBuilder], content: { formats in
                         FormatEnumsView(systemEnum, systemBuilder, formats.keys.sorted())
                     })
                 })
             }, label: {
                 Button(action: {
                     //                self.navigationEnum = .platform(builder, systemBuilder)
                     //                self.navigation.toggle()
                 }, label: {
                     HStack(alignment: .center, spacing: 10) {
                         Text(systemBuilder.rawValue)
                             .foregroundColor(.blue)
                         Spacer()
                     }
                 })
             })
         }
     }
     
     @ViewBuilder
     private func SystemEnumsView(_ systemEnums: [SystemEnum]) -> some View {
         ForEach(systemEnums, id:\.self) { systemEnum in
             OptionalView(self.platforms[systemEnum]) { systems in
                 TopDisclosureGroup(systemEnum, systems.keys.sorted())
             }
         }
         .onDelete(perform: {
             $0.forEach { index in
                 self.platforms[systemEnums[index]] = nil
             }
         })
     }
     
 }
 */
