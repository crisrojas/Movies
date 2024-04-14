//
//  List.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct Movies: View, NetworkGetter {
    
    @State var state = ResourceState.loading
    @State var loadingMore = false
    @State var page = 1
    
    let url: URL
    
    var body: some View {
        switch state {
        case .loading: ProgressView().onAppear(perform: loadData)
        case .success(let data): successView(data)
        case .error(let error): error
        }
    }
    
    func loadData() {
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems?.append(.init(name: "page", value: page.description))
        let url = components!.url!.absoluteString
        fetchData(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let mj = MJ(data: data)
                    if state.isSuccess {
                        state.appendData(mj, keyPath: "results")
                    } else {
                        state = .success(mj)
                    }
                    
                case .failure(let error): state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    @ViewBuilder // @todo
    var cellLoading: some View {
        if loadingMore {
            ProgressView()
        }
    }
    
    func onCellAppear(_ data: [MJ], movie: MJ) {
        if movie.id == data.last?.id {
            page += 1
            loadData()
        }
    }
    
    func successView(_ props: MJ) -> some View {
        let data = props.results.array
        return List(
            data: data,
            onCellAppear: { onCellAppear(data, movie: $0) }
        )
    }
}

extension Movies {
    struct Cell: View {
        
        @Environment(\.theme) var theme: Theme
        let title: String
        let posterURL: URL?
        let overview: String
        
        var body: some View {
            
            HStack(spacing: 24) {
         
                AsyncImage(url: posterURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .overlay(ProgressView())
                }
                .cornerRadius(4)
                .width(70)
                .height(100)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(title)
                        .foregroundColor(theme.textPrimary)
                        .fontWeight(.heavy)
                        .font(.system(.headline, design: .rounded))
                        .lineLimit(2)

                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(overview.prefix(90) + "...")
                            .fontWeight(.bold)
                            .lineLimit(3)
                    }
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(theme.textPrimary)
                    
                }
                
                Spacer()
            }
        }
    }
}


extension Movies {
    struct List: View {
        let data: [MJ]
        var onCellAppear: (MJ) -> Void = { _ in }
        var body: some View {
            SwiftUI.List(data, id: \.id) { movie in
                Cell(props: movie)
                    .onTap(navigateTo: Movie(props: movie))
                    .onAppear(perform: { onCellAppear(movie) })
            }
            .modify {
                if #available(iOS 16.0, *) {
                    $0.scrollContentBackground(.hidden)
                }
            }
            .background(DefaultBackground().fullScreen())
        }
    }
}


extension Movies.Cell {
    init(props: MJ)  {
        title = props.title
        posterURL = props.poster_path.movieImageURL
        overview = props.overview
    }
}
