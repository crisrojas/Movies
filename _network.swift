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
    func dispatch(_ queue: DispatchQueue?, completion: @escaping Completion<Data>) -> Completion<Data> {{ result in
        if let queue {
            queue.async { completion(result) }
        } else {
            completion(result)
        }
    }}
    
    func fetchData(url: URL, dispatchOn queue: DispatchQueue? = nil, completion: @escaping Completion<Data>) {
        
        let dispatch = dispatch(queue, completion: completion)
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                dispatch(.failure(error!))
                return
            }
            
            dispatch(.success(data))
            dp(url.absoluteString + ":")
            dp(data.asString)
            
        }.resume()
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


struct AsyncDecodable<C: View, P: View, E: View, T: Decodable>: View, NetworkGetter {
    
    enum ResourceState {
        case loading
        case success(T)
        case error(String)
    }
    
    @State var state = ResourceState.loading
    
    let url: URL
    
    @ViewBuilder var content: (T) -> C
    @ViewBuilder var placeholder: () -> P
    @ViewBuilder var error: (String) -> E
    
    init(
        url: URL,
        @ViewBuilder content: @escaping (T) -> C,
        @ViewBuilder placeholder: @escaping () -> P = {ProgressView()},
        @ViewBuilder error: @escaping (String) -> E = {Text($0)}
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        self.error = error
    }
    
    var body: some View {
        switch state {
        case .loading: loading()
        case .success(let data): content(data)
        case .error(let error): Text(error)
        }
    }
    
     var jsonDecoder = JSONDecoder()
    
    func loading() -> some View {
        placeholder().onAppear {
            fetchData(url: url) { result in
                switch result {
                case .success(let data):
                    do {
                        let mapped = try jsonDecoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            state = .success(mapped)
                        }
                    } catch {
                        state = .error("Decoding error")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        state = .error(error.localizedDescription)
                    }
                }
            }
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
        placeholder().onAppear {
            fetchData(url: url, dispatchOn: .main) { result in
                switch result {
                case .success(let data): state = .success(data)
                case .failure(let error): state = .error(error.localizedDescription)
                }
            }
        }
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

final class JSONResource: ObservableObject, NetworkGetter {
    @Published var state = JsonState.loading
    func load(url: URL, keyPath: String? = nil) {
        fetchData(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                let json = JSON(data: data)
                let r = keyPath == nil ? json : json[keyPath!]
                main.async { self.state = .success(r) }
                
            case .failure(let error):
                main.async { self.state = .error(error.localizedDescription) }
            }
        }
    }
}

struct AsyncJSON<C: View, P: View, E: View>: View, NetworkGetter {
    
    @State var state = JsonState.loading
    @StateObject var resource = JSONResource()
    
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
    
    var body: some View {
        switch resource.state {
        case .loading: loading()
        case .success(let data): content(data)
        case .error(let error): Text(error)
        }
    }
    
    func loading() -> some View {
        placeholder().onAppear {
            resource.load(url: url, keyPath: keyPath)
//            loadData()
        }
    }
    
    func loadData() {
        fetchData(url: url) { result in
            switch result {
            case .success(let data):
                let json = JSON(data: data)
                let r = keyPath == nil ? json : json[keyPath!]
                main.async { state = .success(r) }
                
            case .failure(let error):
                main.async { state = .error(error.localizedDescription) }
            }
        }
    }
    
//    func mapContent(_ data: Data) -> C { content(result(JSON(data: data))) }

//    var body: some View {
//        AsyncData(
//            url: url,
//            content: mapContent,
//            placeholder: placeholder,
//            error: error
//        )
//    }
}


// https://stackoverflow.com/questions/69214543/how-can-i-add-caching-to-asyncimage
// @todo: handle errors
//struct AsyncImage<C: View, P: View>: View, NetworkGetter {
//    var url: URL?
//    @ViewBuilder var content: (Image) -> C
//    @ViewBuilder var placeholder: () -> P
//    @State var image: Image? = nil
//
//    var body: some View {
//        if let image {
//            content(image)
//        } else {
//            placeholder()
//                .onAppear { downloadPhoto() }
//        }
//    }
//
//    func downloadPhoto() {
//        guard let url else { return }
//        fetchData(url: url) { result in
//            switch result {
//            case .success(let data):
//                if let cache = URLCache.shared.cachedResponse(for: .init(url: url))?.data {
//                    image = UIImage(data: cache)?.image()
//                } else {
//                    URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
//                    image = UIImage(data: data)?.image()
//                }
//            case .failure: break
//            }
//        }
//    }
//
//    private func downloadPhoto() async -> Image? {
//        do {
//            guard let url else { return nil }
//            // @todo: is this really necessary?
//            if let cache = URLCache.shared.cachedResponse(for: .init(url: url))?.data {
//                return UIImage(data: cache)?.image()
//            } else {
//                let (data, response) = try await fetchData(url: url)
//                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
//                return UIImage(data: data)?.image()
//            }
//        } catch {
//            // @todo: handle errors
//            dp("Error downloading: \(error)")
//            return nil
//        }
//    }
//}
