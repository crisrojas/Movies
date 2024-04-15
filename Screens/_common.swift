//
//  _components.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct ScaleDownButtonStyle: ButtonStyle {
    var factor = 0.9
    var duration = 0.1
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? factor : 1)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
}

extension View {
    func onTapScaleDown() -> some View {
        self
            .onTap {}
            .buttonStyle(ScaleDownButtonStyle())
        
    }
}


struct Carousel<Content: View>: View {
    
    let model: JSON
    let spacing: CGFloat
    let content: (JSON) -> Content
    
    var body: some View {
        
        HStack(spacing: spacing) {
            ForEach(model.array, id: \.id.string) { item in
                content(item)
            }
        }
        .scrollify(.horizontal)
    }
}

struct Carousel_Identifiable<Content: View, T: Identifiable>: View {
    
    let model: [T]
    let spacing: CGFloat
    let content: (T) -> Content
    
    var body: some View {
        
        HStack(spacing: spacing) {
            ForEach(model, id: \.id) { item in
                content(item)
            }
        }
        .scrollify(.horizontal)
    }
}

enum TwoColumnsGrid {
    
    
    static let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    static func from<Content: View>(_ items: JSON, content: @escaping (JSON) -> Content) -> some View {
        return LazyVGrid(columns: columns) {
            
            ForEach(items.array, id: \.id.string) { item in
                content(item)
            }
        }
    }
    
    static func from<Content: View, T: Identifiable>(_ items: [T], content: @escaping (T) -> Content) -> some View {
        return LazyVGrid(columns: columns) {
            
            ForEach(items) { item in
                content(item)
            }
        }
    }
}

struct DefaultBackground: View {
    @Environment(\.theme) var theme: Theme

    var body: some View {
        LinearGradient(
            gradient: theme.gradient,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct Card: View {
    @Environment(\.theme) var theme
    let image: String?
    let title: String?
    let genres: String?
    
    var body: some View {
        
        AsyncImage(url: image?.tmdbImageURL) { image in
            image
                .resizable()
                .width(350)
                .height(200)
                .aspectRatio(contentMode: .fill)
                .overlay(linearGradient)
                .overlay(titleAndGenres)
                .cornerRadius(20)
        } placeholder: {
            theme.imgPlaceholder
                .cornerRadius(20)
                .overlay(ProgressView())
        }
        .width(350)
        .height(200)
    }
    
    private let gradient: Gradient = Gradient(
        colors: [
            Color.black.opacity(1),
            Color.black.opacity(0.0)
        ]
    )
}

private extension Card {
    
    var linearGradient: some View {
        
        LinearGradient(
            gradient: gradient,
            startPoint: .bottom,
            endPoint: .top
        )
        .height(150)
        .offset(y: 50)
    }
    
    
    var titleAndGenres: some View {
        
        VStack(alignment: .leading) {
            /// @todo: Make model return a non optional String
            Text(title ?? "Unknown title")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.leading)
            
            /// @todo this is: always nil
            if let safeGenres = genres {
                Text(safeGenres)
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .opacity(0.6)
                    .top(8)
            }
            
        }
        .leading(.s6)
        .offset(y: 40)
        .alignX(.leading)
    }
}

struct GenreButton: View {
    let model: FeaturedGenre
    
    var body: some View {
        model.color
            .cornerRadius(10)
            .shadow(color: model.color.opacity(0.5), radius: 10)
            .height(55)
            .overlay(label)
    }
    
    var label: Text {
        Text(model.rawValue)
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
}
