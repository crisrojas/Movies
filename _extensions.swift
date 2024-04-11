//
//  _extensions.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension String {
    var backdropURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(self)")
    }
}

import SwiftUI

extension String: View {
    public var body: Text { Text(self) }
}


#if DEBUG
extension Result {
    var data: Success? {
        switch self {
        case .success(let data): return data
        case .failure: return nil
        }
    }
}

extension Result where Success == Data {
    var json: String? {
        guard let data else { return nil }
        return data.asString
    }
}

extension Data {
    var asString: String { String(decoding: self, as: UTF8.self) }
}
#endif

