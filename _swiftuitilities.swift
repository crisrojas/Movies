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
    func size(_ value: CGFloat) -> some View {
        self.frame(width: value, height: value)
    }
    
    func width(_ value: CGFloat) -> some View {
        self.frame(width: value)
    }
    
    func height(_ value: CGFloat) -> some View {
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
    func scrollify(_ axis: Axis.Set = .vertical) -> some View {
        
        ScrollView(axis, showsIndicators: false) {
            self
        }
    }
    
    func navigationify() -> some View {
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

