//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct Genres: View {
    
    var body: some View {
        AsyncJSON(url: TMDb.genres)  { response in
            List(response.genres.array, id: \.id) { genre in
                Text(genre.name)
                    .font(.system(.headline, design: .rounded))
                    .onTap(navigateTo: list(genre.id))
            }
            .background(DefaultBackground().fullScreen())
            .modify {
                if #available(iOS 16.0, *) {
                    $0.scrollContentBackground(.hidden)
                }
            }
        }
    }

    func list(_ id: Int) -> Movies {
        Movies(url: TMDb.genre(id: id))
    }
}
