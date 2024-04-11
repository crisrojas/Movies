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
    
    func successView(_ props: MJ) -> some View {
        let data = props.results.array
        return List {
            ForEach(data, id: \.id) { movie in
                Cell(props: movie)
                    .onTap(navigateTo: Movie(props: movie))
                    .onAppear {
                        if movie.id == data.last?.id {
                           page += 1
                           loadData()
                        }
                    }
                
                if loadingMore {
                    ProgressView()
                }
            }
        }
        .modify {
            if #available(iOS 16.0, *) {
                $0.scrollContentBackground(.hidden)
            }
        }
        .background(DefaultBackground().fullScreen())
    }
}

extension Movies {
    struct Cell: View {
        let title: String
        let backdropURL: URL?
        let overview: String
        
        var body: some View {
            
            HStack(spacing: 24) {
         
                AsyncImage(url: backdropURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .overlay(ProgressView())
                }
                .cornerRadius(4)
                .width(66)
                .height(100)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(title)
                        .foregroundColor(.sky900)
                        .fontWeight(.heavy)
                        .font(.system(.headline, design: .rounded))
                        .lineLimit(2)

                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(overview.prefix(90) + "...")
                            .fontWeight(.bold)
                            .lineLimit(3)
                    }
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.sky900)
                    
                }
                
                Spacer()
            }
        }
    }
}

extension Movies.Cell {
    init(props: MJ)  {
        title = props.title
        backdropURL = props.backdrop_path.backdropURL
        overview = props.overview
    }
}
