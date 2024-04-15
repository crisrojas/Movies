//
//  List.swift
//  
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import SwiftUI

struct Movies: View, NetworkGetter {
    
    @State var state = JsonState.loading
    @State var loadingMore = false
    @State var page = 1
    
    let url: URL
    
    var currentURL: URL {
        url.appendingQueryItem("page", value: page)
    }
    
    @State var search = ""
    
    var body: some View {
        _body//.searchable(text: $search)
    }
    
    @ViewBuilder
    var _body: some View {
        switch state {
        case .loading: ProgressView().task { await loadData() }
        case .success(let data): successView(data)
        case .error(let error): error
        }
    }
    
    func loadData() async {
        do {
            let data = try await fetchData(url: currentURL)
            let json = JSON(data: data)
            if state.isSuccess {
                state.appendData(json, keyPath: "results")
            } else {
                state = .success(json)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @ViewBuilder // @todo
    var cellLoading: some View {
        if loadingMore {
            ProgressView()
        }
    }

    func successView(_ props: JSON) -> some View {
        let data = props.results.array
        return List(
            data: data,
            cellTask: { await cellTask(data, movie: $0) }
        )
    }
    
    
    func cellTask(_ data: [JSON], movie: JSON) async {
        if movie.id == data.last?.id {
            page += 1
            await loadData()
        }
    }
}

extension Movies {
    struct List: View {
        
        let data: [JSON]
        var cellTask: (JSON) async -> Void = { _ in }
        
        typealias List = SwiftUI.List
        
        var body: some View {
            List(data, id: \.id) { movie in
                Cell(props: movie)
                    .onTap(navigateTo: Movie(props: movie))
                    .task { await cellTask(movie) }
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

extension Movies.List {
    struct Cell: View {
        
        @Environment(\.theme) var theme: Theme
        let title: String
        let posterURL: URL?
        let overview: String
        
        var body: some View {
            
            HStack(spacing: .s8) {
         
                AsyncImage(url: posterURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .overlay(ProgressView())
                }
                .cornerRadius(4)
                .width(70)
                .height(100)
                
                VStack(alignment: .leading, spacing: .s1) {
                    
                    Text(title)
                        .foregroundColor(theme.textPrimary)
                        .fontWeight(.heavy)
                        .font(.system(.headline, design: .rounded))
                        .lineLimit(2)

                    VStack(alignment: .leading) {
                        
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

extension Movies.List.Cell {
    init(props: JSON)  {
        title = props.title
        posterURL = props.poster_path.tmdbImageURL
        overview = props.overview
    }
}
