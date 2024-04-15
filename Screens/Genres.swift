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
            List(response.genres.array) { genre in
                Text(genre.name)
                    .font(.system(.headline, design: .rounded))
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

    func list(_ id: Int) -> Movies {
        Movies(url: TMDb.genre(id: id))
    }
}

extension Text {
    init(_ json: JSON) {
        self.init(json.stringValue)
    }
}
