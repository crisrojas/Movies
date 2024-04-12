//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

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

struct Genres: View {
    
    var body: some View {
        JSON(url: TmdbApi.genres, keyPath: "genres")  { genres in
            List {
                ForEach(genres.array, id: \.id) { genre in
                    Text(genre.name)
                        .onTap(navigateTo: list(genre.id.intValue))
                }
            }
            .background(DefaultBackground().fullScreen())
            .modify {
                if #available(iOS 16.0, *) {
                    $0.scrollContentBackground(.hidden)
                }
            }
        }
    }
    
    func list(_ id: Int) -> some View {
        Movies(url: TmdbApi.genre(id: id))
    }
}
