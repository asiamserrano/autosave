////
////  GameImageView.swift
////  autosave_ios
////
////  Created by Asia Serrano on 4/11/25.
////
//
//import SwiftUI
//import SwiftUI
//import PhotosUI
//
//struct TestGameImageView: View {
//    
////    @EnvironmentObject public var builder: GameBuilder
//    
//    @State private var photosPickerItem: PhotosPickerItem? = nil
//    @State private var picker: ImagePickerEnum = .picker
//    
//    @Binding var boxart: Data?
//    
//    let edit: EditMode
//    
//    var body: some View {
//        Section {
//            VStack(alignment: .center) {
//                ImageView()
//                    .onTapGesture(count: 2, perform: self.tapAction)
//                HStack {
//                    PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
//                        BoldText(self.isBoxartEmpty ? .add : .edit)
//                    }
//                    .onChange(of: self.photosPickerItem, self.pickerAction)
//                    
//                    Button(action: self.resetPhotosPickerItem, label: {
//                        BoldText(.delete)
//                    })
//                    .hide(isBoxartEmpty)
//                }
//                .show(isEditing)
//                .buttonStyle(.borderless)
//            }
//        }
//        .show(isLibrary)
//    }
//    
//}
//
//private extension TestGameImageView {
//    
//    var isBoxartEmpty: Bool { self.boxart == nil }
//    var isEditing: Bool { self.edit == .active }
//        
//    func setData(_ data: Data?, _ picker: ImagePickerEnum) -> Void {
//        withAnimation {
//            self.boxart = data
//            self.setPicker(picker)
//        }
//    }
//    
//    func setPicker(_ picker: ImagePickerEnum) -> Void {
//        self.picker = picker
//    }
//    
//    func resetPhotosPickerItem() -> Void {
//        self.photosPickerItem = nil
//    }
//    
//    func tapAction() -> Void {
//        if self.isEditing, let image: UIImage = UIPasteboard.general.images?.first {
//            self.setData(image.data, .paste)
//            self.resetPhotosPickerItem()
//        }
//    }
//    
//    func pickerAction(_ old: PhotosPickerItem?, _ new: PhotosPickerItem?) -> Void {
//        if self.picker == .paste {
//            self.setPicker(.picker)
//        } else {
//            Task {
//                let data: Data? = try? await self.photosPickerItem?.loadTransferable(type: Data.self)
//                self.setData(data, .picker)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func BoldText(_ constant: ConstantEnum) -> some View {
//        CustomText(constant)
//            .bold()
//    }
//    
//    @ViewBuilder
//    func ImageView() -> some View {
//        let uiimage: UIImage = UIImage(self.boxart)
//        let deviceImage: Image = Image(uiimage)
//        
//        BooleanView(isBoxartEmpty, trueView: {
//            deviceImage
//                .resizable()
//                .scaledToFit()
//                .frame(maxWidth: appScreenWidth, alignment: .center)
//                .foregroundColor(.gray)
//                .padding()
//        }, falseView: {
//            deviceImage
//                .resizable()
//                .scaledToFit()
//                .cornerRadius(10)
//                .shadow(radius: 10)
//                .padding()
//        })
//    }
//    
//}
