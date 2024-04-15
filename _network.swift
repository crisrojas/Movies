//
//  _network.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import Foundation

func dp(_ msg: Any) {
    #if DEBUG
        print(msg)
    #endif
}

enum TMDb {
    
    static let apiKey = "b5f1e193c3a2759a19f3f085f3dc2d7e"

    static var baseComponents: URLComponents {
        var components = URLComponents(string: "https://api.themoviedb.org/3")
        let items = URLQueryItem(name: "api_key", value: apiKey)
        components?.queryItems = [items]
        return components!
    }

    static var baseURL: URL { baseComponents.url! }
    
    // Resources
    static let popular = baseURL.appendingPathComponent("movie/popular")
    static let now_playing = baseURL.appendingPathComponent("movie/now_playing")
    static let genres = baseURL.appendingPathComponent("genre/movie/list")
   
    static func movie(id: Int) -> URL {
        baseURL.appendingPathComponent("/movie/\(id)")
    }
    
    static func videos(id: Int) -> URL {
        baseURL.appendingPathComponent("/movie/\(id)/videos")
    }
    
    static func credits(id: Int) -> URL {
        baseURL.appendingPathComponent("/movie/\(id)/credits")
    }
    
    static func genre(id: Int) -> URL {
        var components = baseComponents
        components.queryItems?.append(.init(name: "with_genres", value: id.description))
        return components.url!.appendingPathComponent("discover/movie")
    }
}


typealias Completion<T> = (Result<T, Error>) -> Void

protocol NetworkGetter {}
extension NetworkGetter {
    func fetchData(url: URL, completion: @escaping Completion<Data>) {
        
    }
    func fetchData(url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url)
    }
}

import SwiftUI

enum JsonState {
    case loading
    case success(JSON)
    case error(String)
}

extension JsonState {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        default: return false
        }
    }
    
    var data: JSON? {
        switch self {
        case .success(let data): return data
        default: return nil
        }
    }
    
    mutating func appendData(_ newData: JSON, keyPath: String) {
        guard let data else { return }
        let finalData = data[keyPath].array + newData[keyPath].array
        let anyArray: [Any] = finalData.map { $0.jsonObject }
        let jsonObject: [String: Any] = [keyPath: anyArray]
        let magicJSON = JSON.dict(jsonObject)
        self = .success(magicJSON)
    }
}

extension JsonState {
    init(from result: Result<JSON, Error>) {
        switch result {
        case .success(let data): self = .success(data)
        case .failure(let error): self = .error(error.localizedDescription)
        }
    }
}

struct AsyncJSON<C: View, P: View, E: View>: View {
    
    @State var state = JsonState.loading
    
    let url: URL
    let keyPath: String?
    
    @ViewBuilder var content: (JSON) -> C
    @ViewBuilder var placeholder: () -> P
    @ViewBuilder var error: (String) -> E
    
    init(
        url: URL,
        keyPath: String? = "results",
        delay: UInt64? = nil,
        @ViewBuilder content: @escaping (JSON) -> C,
        @ViewBuilder placeholder: @escaping () -> P = {ProgressView()},
        @ViewBuilder error: @escaping (String) -> E = {Text($0)}
    ) {
        self.url = url
        self.keyPath = keyPath
        self.content = content
        self.placeholder = placeholder
        self.error = error
    }
    
    // If specified keyPath for json, returns json object for that path
    // Otherwise returns the whole json
    func result(_ json: JSON) -> JSON {
        keyPath == nil ? json : json[keyPath!]
    }
    
    func mapContent(_ data: Data) -> C { content(result(JSON(data: data))) }

    var body: some View {
        AsyncData(
            url: url,
            content: mapContent,
            placeholder: placeholder,
            error: error
        )
    }
}


// https://stackoverflow.com/questions/69214543/how-can-i-add-caching-to-asyncimage
// @todo: handle errors
struct AsyncImage<C: View, P: View>: View, NetworkGetter {
    var url: URL?
    @ViewBuilder var content: (Image) -> C
    @ViewBuilder var placeholder: () -> P
    @State var image: Image? = nil

    var body: some View {
        if let image {
            content(image)
        } else {
            placeholder()
                .task { image = await downloadPhoto() }
        }
    }
    
    private func downloadPhoto() async -> Image? {
        do {
            guard let url else { return nil }
            // @todo: is this really necessary?
            if let cache = URLCache.shared.cachedResponse(for: .init(url: url))?.data {
                return UIImage(data: cache)?.image()
            } else {
                let (data, response) = try await fetchData(url: url)
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
                return UIImage(data: data)?.image()
            }
        } catch {
            // @todo: handle errors
            dp("Error downloading: \(error)")
            return nil
        }
    }
}

struct AsyncData<C: View, P: View, E: View>: View, NetworkGetter {
    
    enum ResourceState {
        case loading
        case success(Data)
        case error(String)
    }
    
    @State var state = ResourceState.loading
    
    let url: URL
    
    @ViewBuilder var content: (Data) -> C
    @ViewBuilder var placeholder: () -> P
    @ViewBuilder var error: (String) -> E
    
    var body: some View {
        switch state {
        case .loading: loading()
        case .success(let data): content(data)
        case .error(let error): Text(error)
        }
    }
    
    func loading() -> some View {
        placeholder().task {
            do {
                let (data, _) = try await fetchData(url: url)
                state = .success(data)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
