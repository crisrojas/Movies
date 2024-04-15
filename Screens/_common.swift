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

enum TwoColumnsGrid {
    
    static let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    static func from<Content: View>(_ items: JSON, spacing: CGFloat? = nil, content: @escaping (JSON) -> Content) -> some View {
        return LazyVGrid(columns: columns, spacing: spacing) {
            
            ForEach(items.array, id: \.self) { item in
                content(item)
            }
        }
    }
    
    static func from<Content: View, T: Identifiable>(_ items: [T], spacing: CGFloat? = nil, content: @escaping (T) -> Content) -> some View {
        return LazyVGrid(columns: columns, spacing: spacing) {
            
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

struct Backdrop: View {
    @Environment(\.theme) var theme
    let image: String?
    let title: String
    let genres: String?
    
    var body: some View {
        
        AsyncImage(url: image?.tmdbImageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(linearGradient)
                .overlay(titleAndGenres, alignment: .bottomLeading)
        } placeholder: {
            theme.imgPlaceholder
                .overlay(ProgressView())
        }
        .cornerRadius(.s5)
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

private extension Backdrop {
    
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
            Text(title)
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
                .frame(width: 350 - .s8, alignment: .leading)
                .lineLimit(1)
                .foregroundColor(Color.white)
            
            if let genres {
                Text(genres)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                    .opacity(0.6)
            }
            
        }
        .offset(x: .s4, y: -.s4)
    }
}

extension Backdrop {
    init(props: JSON) {
        self.title = props.title.stringValue
        self.image = props.backdrop_path.string
        self.genres = props.genre_ids.array.map { $0.stringValue }.joined(separator: ", ") // @todo
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
