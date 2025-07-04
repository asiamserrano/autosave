//
//  GameImageView.swift
//  autosave_ios
//
//  Created by Asia Serrano on 4/11/25.
//

import SwiftUI
import SwiftUI
import PhotosUI

struct GameImageView: Gameopticable {
    
    @EnvironmentObject public var builder: GameBuilder
    
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var picker: ImagePickerEnum = .picker
    
//    let isEditing: Bool
    
//    init(_ isEditing: Bool) {
//        self.isEditing = isEditing
//    }
    
    var body: some View {
        OptionalView(isLibrary) {
            Section {
                VStack(alignment: .center) {
                    ImageView()
                        .onTapGesture(count: 2, perform: self.tapAction)
                    OptionalView(isEditing) {
                        HStack {
                            PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                                BoldCustomText(self.isBoxartEmpty ? .add : .edit)
                            }
                            .onChange(of: self.photosPickerItem, self.pickerAction)
                            
                            OptionalView(isBoxartNotEmpty) {
                                Button(action: self.resetPhotosPickerItem, label: {
                                    BoldCustomText(.delete)
                                })
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
    }
    
}

private extension GameImageView {
    
    func setData(_ data: Data?, _ picker: ImagePickerEnum) -> Void {
        withAnimation {
            self.builder.boxart = data
            self.setPicker(picker)
        }
    }
    
    func setPicker(_ picker: ImagePickerEnum) -> Void {
        self.picker = picker
    }
    
    func resetPhotosPickerItem() -> Void {
        self.photosPickerItem = nil
    }
    
    func tapAction() -> Void {
        if self.isEditing, let image: UIImage = UIPasteboard.general.images?.first {
            self.setData(image.data, .paste)
            self.resetPhotosPickerItem()
        }
    }
    
    func pickerAction(_ old: PhotosPickerItem?, _ new: PhotosPickerItem?) -> Void {
        if self.picker == .paste {
            self.setPicker(.picker)
        } else {
            Task {
                let data: Data? = try? await self.photosPickerItem?.loadTransferable(type: Data.self)
                self.setData(data, .picker)
            }
        }
    }
    
    @ViewBuilder
    func BoldCustomText(_ constant: ConstantEnum) -> some View {
        CustomText(constant)
            .bold()
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        let uiimage: UIImage = UIImage(self.boxart)
        let deviceImage: Image = Image(uiimage)
        if isBoxartEmpty {
            deviceImage
                .resizable()
                .scaledToFit()
                .frame(maxWidth: appScreenWidth, alignment: .center)
                .foregroundColor(.gray)
                .padding()
            
        } else {
            deviceImage
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
        }
    }
    
}
