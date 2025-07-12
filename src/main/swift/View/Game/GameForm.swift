////
////  GameForm.swift
////  autosave
////
////  Created by Asia Michelle Serrano on 5/7/25.
////
//
//import SwiftUI
//
//struct GameForm: Gameopticable {
//    
//    @Environment(\.modelContext) private var modelContext
//        
//    @Environment(\.dismiss) private var dismiss
//    
//    @StateObject public var builder: GameBuilder
//    
//    @State private var snapshot: GameSnapshot
//    
//    init(_ builder: GameBuilder) {
//        let snapshot: GameSnapshot = builder.snapshot
//        self._builder = .init(wrappedValue: builder)
//        self._snapshot = .init(wrappedValue: snapshot)
//    }
//    
//    init(_ status: GameStatusEnum) {
//        let builder: GameBuilder = .init(status)
//        self.init(builder)
//    }
//        
//    var body: some View {
//        NavigationStack {
//            Form {
//                GameImageView()
//                
//                Section {
//                    CustomTextField(.title, $builder.title)
//                }
//                Section {
//                    CustomDatePicker(.release_date, $builder.release)
//                }
//            }
//            .environmentObject(self.builder)
//            .navigationBarBackButtonHidden()
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    CustomButton(.cancel) {
//                        self.builder.cancel(self.snapshot)
//                        dismiss()
//                    }
//                }
////                ToolbarItem(placement: .confirmationAction) {
////                    CustomButton(.done) {
////                        let result: GameResult = self.modelContext.save(self.snapshot, self.builder)
////                        if result.successful {
////                            self.dismiss()
////                        } else {
////                            self.builder.fail()
////                        }
////                    }
////                    .disabled(self.builder.isDisabled)
////                }
//            }
//        }
//    }
//}
