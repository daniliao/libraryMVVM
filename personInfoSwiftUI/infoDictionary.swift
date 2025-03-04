//
//  infoDictionary.swift
//  personInfoSwiftUI
//
//  Created by Janaka Balasooriya on 2/11/23.
//
// ViewModel

import Foundation
class infoDictionary: ObservableObject
{
    // dictionary that stores books
    @Published var infoRepository : [Int:personRecord] = [Int:personRecord] ()
    @Published var index: Int = 0
    
    init() { }
  
    func add(_ author:String, _ title:String, _ genre:String, _ price:String)
    {
        // send to viewModel to create a personRecord object and then saved into the dict
        let pRecord =  personRecord(n: author, s:title, a: genre, p: price, id: UUID())
        infoRepository[index] = pRecord // add into dict
        index += 1
        for (_, value) in infoRepository {
            print("Title: \(value.title ?? "Unknown"), Author: \(value.author ?? "Unknown"), Genre: \(value.genre ?? "Unknown"), Price: \(value.price ?? "Unknown"))")
        }
    }
    
    func getBook(index: Int) -> personRecord? {
        return infoRepository[index]
    }
    
    func getFirstAvailableBook() -> String? {
        for (_, info) in infoRepository {
            print("Book title: \(info.title ?? "Unknown")")
            if let title = info.title, !title.isEmpty {
                return title
            }
        }
        return nil
    }
    
    
    
    func getCount() -> Int
    {
        return infoRepository.count
    }
    
    func findExistingIndex() -> Int {
        var index = 0
        while infoRepository.keys.contains(index) {
            index += 1
        }
        return index
    }
    
    
    func search(s: String) -> personRecord? {
        for (_, record) in infoRepository {
            if record.title == s {
                return record
            }
        }
        return nil
    }
    func deleteRec(s: String) {
        if let key = infoRepository.first(where: { $0.value.title == s })?.key {
            infoRepository.removeValue(forKey: key)
        }
    }

}
