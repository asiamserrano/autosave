//
//  SortedMapView.swift
//  autosave
//
//  Created by Asia Serrano on 8/10/25.
//

import SwiftUI

struct SortedMapView<M: SortedMapProtocol, T: View>: View {
        
    typealias E = (M.Element) -> T
    typealias KV = (M.K, M.V) -> T
    
    private enum Content { case e(E), kv(KV) }
    
    private let m: M
    private let content: Content
    
    private init(_ m: M, _ content: Content) {
        self.m = m
        self.content = content
    }
    
    init(_ m: M, @ViewBuilder content: @escaping E) {
        self.init(m, .e(content))
    }
    
    init(_ m: M, @ViewBuilder content: @escaping KV) {
        self.init(m, .kv(content))
    }
    
    var body: some View {
        QuantifiableView(m) { map in
            ForEach(map, id:\.self) { (element: M.Element) in
                switch content {
                case .e(let e):
                    e(element)
                case .kv(let kv):
                    kv(element.key, element.value)
                }
            }
        }
    }
    
}
