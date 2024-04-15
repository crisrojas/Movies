//
//  _swiftuitilities.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

extension View {
    
    // padding
    
    func top(_ value: CGFloat) -> some View {
        self.padding(.top, value)
    }
    
    func vertical(_ value: CGFloat) -> some View {
        self.padding(.vertical, value)
    }
    
    func horizontal(_ value: CGFloat) -> some View {
        self.padding(.horizontal, value)
    }
    
    func bottom(_ value: CGFloat) -> some View {
        self.padding(.bottom, value)
    }
    
    func leading(_ value: CGFloat) -> some View {
        self.padding(.leading, value)
    }
    
    func trailing(_ value: CGFloat) -> some View {
        self.padding(.trailing, value)
    }
    
    
    // frame
    func size(_ value: CGFloat?) -> some View {
        self.frame(width: value, height: value)
    }
    
    func width(_ value: CGFloat?) -> some View {
        self.frame(width: value)
    }
    
    func height(_ value: CGFloat?) -> some View {
        self.frame(height: value)
    }
    
    
    /// Returns a view taking the whole screen width & height available.
    /// Ignores safe area
    func fullScreen() -> some View {
        self
            .frame(width: UIScreen.main.bounds.size.width)
            .frame(height: UIScreen.main.bounds.size.height)
            .edgesIgnoringSafeArea(.all)
    }
    
    // wrappers
    func scrollify(_ axis: Axis.Set = .vertical) -> ScrollView<Self> {
        
        ScrollView(axis, showsIndicators: false) {
            self
        }
    }
    
    func scrollify(_ axis: Axis.Set = .vertical, onScroll: @escaping (CGFloat) -> Void) -> some View {
        ScrollView(axis, showsIndicators: false) {
            self.background(
                GeometryReader {
                    Color.clear.preference(
                        key: ViewOffsetKey.self,
                        value: -$0.frame(in: .named("scroll")).origin.y
                    )
                }
            )
            .onPreferenceChange(ViewOffsetKey.self) { offset in
                onScroll(offset)
            }
        }
        .coordinateSpace(name: "scroll")
    }
    
    func navigationify() ->  NavigationView<Self> {
        NavigationView { self }
    }
    
    func onTap<Destination: View>(navigateTo destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            self
        }
    }
    
    func onTap(perform: @escaping () -> ()) -> some View {
        Button {
            perform()
        } label: {
            self
        }
    }
    
    // alignment
    
    func alignX(_ alignment: HorizontalAlignment) -> some View  {
        
        HStack(spacing: 0) {
            switch alignment {
            case .leading:
                self
                Spacer()
            case .center:
                Spacer()
                self
                Spacer()
            case .trailing:
                Spacer()
                self
            default:
                self
            }
        }
    }
}

extension View {
    // Optional so we can conditionally use it
    func statusBarBackground<Background: View>(_ background: Background) -> some View {
        self.overlay(alignment: .top) {
            Color.clear
                .background(background)
                .ignoresSafeArea(edges: .top)
                .height(0)
        }
    }
    
    @ViewBuilder
    func statusBarBackground(_ background: Material?) -> some View {
            self.overlay(alignment: .top) {
                Color.clear
                    .background(background ?? .thinMaterial)
                    .opacity(background != nil ? 1 : 0)
                    .ignoresSafeArea(edges: .top)
                    .height(0)
            
        }
    }
}
extension View {
    @ViewBuilder
    func modify(@ViewBuilder _ transform: (Self) -> (some View)) -> some View {
        transform(self)
    }
    
    
    
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<T>(_ variable: T?, transform: (Self, T) -> some View) -> some View {
        if let variable {
            transform(self, variable)
        } else {
            self
        }
    }
}


struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
