//
//  personRecord.swift
//  personInfoSwiftUI
//
//  Created by Janaka Balasooriya on 2/11/23.
//
// Model

import Foundation
class personRecord
{
    var author:String? = nil
    var title:String? = nil
    var genre:String? = nil
    var price:String? = nil
    var id: UUID
    
    init(n:String, s:String, a:String, p:String, id:UUID) {
        self.author = n
        self.title = s
        self.genre = a
        self.price = p
        self.id = UUID()
    }
    
    func change_genre(newgenre:String)
    {
        self.genre = newgenre;
    }
    
    
}
