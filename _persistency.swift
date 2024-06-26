//
//  _persistency.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 12/04/2024.
//

import Foundation


enum FileBase {
    static let favorites = JsonResource("favorites")
    static let ratings   = JsonResource("ratings")
}


final class JsonResource: ObservableObject {

    // Prevents writes on init
    var isInitializing = true
    @Published var data = JSON.array([]) {
        didSet { if !isInitializing { persist() } }
    }
    
    var items: [JSON] {data.array}
    
    let path: String
    init(_ path: String) {
        self.path = path + ".txt"
        data = read()
        isInitializing = false
    }
    
    func contains(_ itemId: String) -> Bool {read(id: itemId) != nil}
   
    func read() -> JSON {
        do {
            let data = try Data(contentsOf: fileURL())
            return try JSON(data: data)
        } catch {
            dp("Error reading file: \(error)")
            return .array([])
        }
    }
    
    func read(id: String) -> JSON? {data.array.first(where: {$0.id.string == id})}
    
    func add(_ item: JSON) {
        let new = data.array + [item]
        data = .array(new)
    }
    
    func delete(_ item: JSON) {
        var array = data.array
        if let index = array.firstIndex(where: {$0.id == item.id}) {
            array.remove(at: index)
        }
        data = .array(array)
    }
    
    func persist() {
        guard let data = try? data.encode() else {
            dp("Failed to encode MagicJSON")
            return
        }

        do {
            try data.write(to: fileURL())
            dp("Successfully wrote to \(path)")
        } catch {
            dp("Error writing file: \(error)")
        }
    }
    
    func destroy() {data = .array()}
    
    func fileURL() throws -> URL {
        try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(path)
    }
}
