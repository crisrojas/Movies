//
//  File.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 12/04/2024.
//

import SwiftUI

struct Favorites: View {
    @StateObject var favorites = FileBase.favorites
    var body: some View {
        List(favorites.items, id: \.id) { item in
            Text(item.title)
        }
    }
}
