//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct Genres: View {
    
    var body: some View {
        JSON(TmdbApi.genres, keyPath: "genres")  { genres in
            List(genres.array, id: \.id) { genre in
                Text(genre.name)
                    .onTap(navigateTo: list(genre.id.intValue))
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
