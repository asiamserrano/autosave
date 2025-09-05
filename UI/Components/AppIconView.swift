//
//  AppIconView.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 5/7/25.
//

import SwiftUI

public struct AppIconView: View {

    private var iconName: AppIcon
    private var iconColor: Color
    private var iconWidth: CGFloat
    private var iconHeight: CGFloat

    public init(_ n: AppIcon, _ w: CGFloat?, _ h: CGFloat?,  _ c: Color?) {
        self.iconName = n
        self.iconColor = c ?? .pink
        self.iconWidth = w ?? .defaultSize
        self.iconHeight = h ?? .defaultSize
    }

    public init(_ n: AppIcon) {
        self = .init(n, nil, nil, nil)
    }

    public init(_ n: AppIcon, _ c: Color) {
        self = .init(n, nil, nil, c)
    }

    public init(_ n: AppIcon, _ c: Color, _ h: CGFloat) {
        self = .init(n, h, h, c)
    }

    public init(_ n: AppIcon, _ w: CGFloat, _ h: CGFloat) {
        self = .init(n, w, h, nil)
    }

    public init(_ n: AppIcon, _ c: CGFloat) {
        self = .init(n, c, c, nil)
    }

    public var body: some View {
        Image(iconName)
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth, height: iconHeight)
            .foregroundColor(iconColor)
    }

}
