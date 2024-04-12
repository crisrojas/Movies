//
//  _persistency.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 12/04/2024.
//

import Foundation

final class FileResource: ObservableObject {
    @Published var data = MJ.arr([]) {
        didSet { persist() }
    }
    
    let path: String
    init(_ path: String) {
        self.path = path + ".txt"
        data = read()
    }
    
    fileprivate let jsonDecoder = JSONDecoder()
    
    func contains(_ itemId: String) -> Bool {read(id: itemId) != nil}
   
    func read() -> MagicJSON {
        do {
            let data = try Data(contentsOf: fileURL())
            return MagicJSON(data: data)
        } catch {
            print("Error reading file: \(error)")
            return .arr([])
        }
    }
    
    func read(id: String) -> MJ? {data.array.first(where: {$0.id == id})}
    func add(_ item: MJ) {
        let new = data.array + [item]
        data = .arr(new)
    }
    func delete(_ item: MJ) {
        var array = data.array
        if let index = array.firstIndex(where: {$0.id == item.id}) {
            array.remove(at: index)
        }
        data = .arr(array)
    }
    
    func persist() {
        guard let data = try? data.encode() else {
            print("Failed to encode MagicJSON")
            return
        }
        
        do {
            try data.write(to: fileURL())
            print("Successfully wrote to \(path)")
        } catch {
            print("Error writing file: \(error)")
        }
    }
    
    
    func fileURL() throws -> URL {
        try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(path)
    }
}
