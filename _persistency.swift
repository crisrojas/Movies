//
//  _persistency.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 12/04/2024.
//

import Foundation


enum FileBase {
    static let favorites = FileResource("favorites")
    static let ratings   = FileResource("ratings")
}


final class FileResource: ObservableObject {

    // @todo: Find a better way of preventing calling persist()
    var endedInitialization = false
    @Published var data = JSON.arr([]) {
        didSet { if endedInitialization { persist() } }
    }
    
    var items: [JSON] {data.array}
    
    let path: String
    init(_ path: String) {
        self.path = path + ".txt"
        data = read()
        endedInitialization = true
    }
    
    func contains(_ itemId: String) -> Bool {read(id: itemId) != nil}
   
    func read() -> JSON {
        do {
            let data = try Data(contentsOf: fileURL())
            return JSON(data: data)
        } catch {
            dp("Error reading file: \(error)")
            return .arr([])
        }
    }
    
    func read(id: String) -> JSON? {data.array.first(where: {$0.id == id})}
    
    func add(_ item: JSON) {
        let new = data.array + [item]
        data = .arr(new)
    }
    
    func delete(_ item: JSON) {
        var array = data.array
        if let index = array.firstIndex(where: {$0.id == item.id}) {
            array.remove(at: index)
        }
        data = .arr(array)
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
    
    func destroy() { }
    
    
    func fileURL() throws -> URL {
        try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(path)
    }
}
