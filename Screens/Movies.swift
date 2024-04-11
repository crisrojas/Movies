//
//  List.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct Movies: View {
    let url: URL
    var body: some View {
        JSON(url: url) { result in
            List {
                ForEach(result.array, id: \.id) { movie in
                    Cell(props: movie)
                        .onTap(navigateTo: Movie(props: movie))
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
}

extension Movies {
    struct Cell: View {
        let props: MJ
        var body: some View {
            
            HStack(spacing: 24) {
         
                AsyncImage(url: props.backdrop_path.backdropURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .overlay(ProgressView())
                }
                .cornerRadius(4)
                .width(66)
                .height(100)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(props.title ?? "Unknown title")
                        .foregroundColor(.sky900)
                        .fontWeight(.heavy)
                        .font(.system(.headline, design: .rounded))

                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(props.overview.prefix(90) + "...")
                            .fontWeight(.bold)
                        Text(props.ratingText)
                    }
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.sky900)
                    
                }
                
                Spacer()
            }
        }
    }
}
