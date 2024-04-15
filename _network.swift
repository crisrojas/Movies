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
    func dispatch<T>(_ queue: DispatchQueue?, completion: @escaping Completion<T>) -> Completion<T> {{ result in
        if let queue {
            queue.async { completion(result) }
        } else {
            completion(result)
        }
    }}
    
    func fetchData(url: URL, dispatchOn queue: DispatchQueue? = nil, completion: @escaping Completion<JSON>) {
        let dispatch = dispatch(queue, completion: completion)
        fetchData(url: url) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                // Not sure if dispatching decoding in a different queue
                // really helps...
                DispatchQueue.global(qos: .background).async {
                    do {
                        let json = try JSON(data: data)
                        dispatch(.success(json))
                    } catch {
                        dispatch(.failure(error))
                    }
                }
            case .failure(let error): dispatch(.failure(error))
            }
        }
    }
    
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
        }.resume()
    }
    
    func fetchData(url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url)
    }
}

import SwiftUI

enum JsonState: Equatable {
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
    
    mutating func appendData(_ newData: JSON) {
        guard let data else { return }
        let current = data.array
        let new = newData.array
        let final = current + new
        self = .success(.array(final))
    }
}

struct AsyncJSON<C: View, P: View, E: View>: View, NetworkGetter {
    
    enum ResourceState {
        case loading
        case success(JSON)
        case error(Error)
    }
    
    @State var state = ResourceState.loading
    
    let url: URL
    let keypath: String?
    
    @ViewBuilder var content: (JSON) -> C
    @ViewBuilder var placeholder: () -> P
    @ViewBuilder var error: (String) -> E
   
    init(
        url: URL,
        keyPath: String? = nil,
        @ViewBuilder content: @escaping (JSON) -> C,
        @ViewBuilder placeholder: @escaping () -> P = {ProgressView()},
        @ViewBuilder error: @escaping (String) -> E = {Text($0)}
    ) {
        self.url = url
        self.keypath = keyPath
        self.content = content
        self.placeholder = placeholder
        self.error = error
    }
    
    
    var body: some View {
        switch state {
        case .loading: loading()
        case .success(let data): content(data)
        case .error(let error): self.error(error.localizedDescription)
        }
    }
    
    func loading() -> some View {
        placeholder().onAppear {
            fetchData(url: url, dispatchOn: .main) { result in
                switch result {
                case .success(let data):
                    state = .success(data)
                case .failure(let error):
                    state = .error(error)
                }
            }
        }
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
        case .error(let error): self.error(error)
        }
    }
    
     var jsonDecoder = JSONDecoder()
    
    func loading() -> some View {
        placeholder().onAppear {
            fetchData(url: url) { result in
                switch result {
                case .success(let data):
                    do {
                        // Not usre if this is needed
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


// https://stackoverflow.com/questions/69214543/how-can-i-add-caching-to-asyncimage
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
