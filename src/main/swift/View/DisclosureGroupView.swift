//
//  DisclosureGroupView.swift
//  autosave
//
//  Created by Asia Serrano on 8/13/25.
//

import SwiftUI

struct DisclosureGroupView: View {
    
    typealias BoolMap = [Bool: [String]]
    typealias UUIDMap = [UUID: BoolMap]
    typealias IntMap = [Int: UUIDMap]
    
    @State private var content: IntMap = .init()
    
    private let int_array: [Int]
    private let uuid_array: [UUID]
    
    init(_ i: [Int], _ u: [UUID]) {
        self.int_array = i
        self.uuid_array = u
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                WrapperView(self.content.keys.sorted()) { ints in
                    Section {
                        ForEach(ints, id:\.self) { int in
                            OptionalView(self.content[int]) { uuidMap in
                                Text("size for \(int): \(uuidMap.count)")
                            }
                        }
                    }
                    
                    IntsView(ints)
                }
             
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        
                        if let int: Int = int_array.randomElement(), let uuid: UUID = uuid_array.randomElement() {
                            let bool: Bool = .random()
                            
                            var uuidMap: UUIDMap = self.content[int] ?? .defaultValue
                            var boolMap: BoolMap = uuidMap[uuid] ?? .defaultValue
                            var array: [String] = boolMap[bool] ?? .defaultValue
                            
                            array.append(.random)
                            
                            print("uuid: \(uuid.uuidString)")
                            
                            boolMap[bool] = array
                            uuidMap[uuid] = boolMap
                            self.content[int] = uuidMap
                        }
                    }, label: {
                        Text("Add")
                    })
                })
                
            }
        }
    }
    
    @ViewBuilder
    private func IntsView(_ ints: [Int]) -> some View {
        ForEach(ints, id:\.self) { int in
            OptionalView(self.content[int]) { uuidMap in
                TopDisclosureGroup(int, uuidMap.keys.sorted())
            }
        }
        .onDelete(perform: {
            $0.forEach { index in
                self.content[ints[index]] = nil
            }
        })
        
    }
    
    @ViewBuilder
    private func CenterDisclosureGroup(_ int: Int, _ uuid: UUID, _ bool: Bool, _ arr: [String]) -> some View {
        DisclosureGroup(content: {
            ForEach(arr, id:\.self) { str in
                HStack(spacing: 15) {
                    IconView(.arrow_right, .blue)
                    Text(str)
                }
            }
            .onDelete(perform: {
                $0.forEach { index in
                    var new: [String] = arr
                    new.remove(at: index)
                    
                    var uuidMap: UUIDMap = self.content[int] ?? .defaultValue
                    var boolMap: BoolMap = uuidMap[uuid] ?? .defaultValue
                    
                    boolMap[bool] = new.isEmpty ? nil : new
                    uuidMap[uuid] = boolMap.isEmpty ? nil : boolMap
                    self.content[int] = uuidMap.isEmpty ? nil : uuidMap
                }
            })
        }, label: {
            HStack {
                IconView(.arrow_right, .blue)
                Text(bool.description)
            }
        })
    }
    
    @ViewBuilder
    private func BoolsView(_ int: Int, _ uuid: UUID, _ bools: [Bool]) -> some View {
        ForEach(bools, id:\.self) { bool in
            OptionalView(self.content[int], content: { uuidMap in
                OptionalView(uuidMap[uuid], content: { boolMap in
                    OptionalView(boolMap[bool], content: {
                        CenterDisclosureGroup(int, uuid, bool, $0)
                    })
                })
            })
        }
        .onDelete(perform: {
            $0.forEach { index in
                
                var uuidMap: UUIDMap = self.content[int] ?? .defaultValue
                var boolMap: BoolMap = uuidMap[uuid] ?? .defaultValue
                                
                boolMap[bools[index]] = nil
                uuidMap[uuid] = boolMap.isEmpty ? nil : boolMap
                self.content[int] = uuidMap.isEmpty ? nil : uuidMap
            }
        })
    }
    
    @ViewBuilder
    private func TopDisclosureGroup(_ int: Int, _ uuids: [UUID]) -> some View {
        ForEach(uuids, id:\.self) { uuid in
            DisclosureGroup(content: {
                OptionalView(self.content[int], content: { uuidMap in
                    OptionalView(uuidMap[uuid], content: { boolMap in
                        BoolsView(int, uuid, boolMap.keys.map { $0 })
                    })
                })
            }, label: {
                Button(action: {
                    //                self.navigationEnum = .platform(builder, systemBuilder)
                    //                self.navigation.toggle()
                }, label: {
                    HStack(alignment: .center, spacing: 10) {
                        Text(uuid.description)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                })
            })
        }
    }
    
    
}

#Preview {
    
    var int_array: [Int] {
        var new: [Int] = .init()
        for x in 0..<2 {
            new.append(x + 1)
        }
        return new
    }
    
    var uuid_array: [UUID] {
        var new: [UUID] = .init()
        var uuid: UUID
        while new.count < 2 {
            uuid = .init()
            new.append(uuid)
            print("start uuid: \(uuid.uuidString)")
        }
        return new
    }
    
    return DisclosureGroupView(int_array, uuid_array)
}
