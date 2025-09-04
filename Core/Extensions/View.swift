//
//  View.swift
//  autosave
//
//  Created by Asia Serrano on 5/8/25.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder
    public func FormattedView(_ key: String, _ value: String) -> some View {
        HStack {
            HStack {
                Text(key)
                    .foregroundColor(.gray)
                Spacer()
            }
            .frame(width: 95)
            Text(value)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
        }
    }
    
    @ViewBuilder
    public func FormattedView(_ key: AppString, _ value: String) -> some View {
        FormattedView(key.rawValue, value)
    }
    
    @ViewBuilder
    public func CustomText(_ constant: AppString) -> some View {
        Text(constant.rawValue)
    }
    
    @ViewBuilder
    public func CustomDatePicker(_ constant: AppString, _ binding: Binding<Date>) -> some View {
        DatePicker(constant.rawValue, selection: binding, displayedComponents: .date)
    }
    
    @ViewBuilder
    public func CustomButton(_ constant: AppString, _ action: @escaping () -> Void) -> some View {
        Button(constant.rawValue, action: action)
    }
    
}
