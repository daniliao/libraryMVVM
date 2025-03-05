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
    
    init(n:String, s:String, a:String, p:String) {
        self.author = n
        self.title = s
        self.genre = a
        self.price = p
    }
    
    func change_genre(newgenre:String)
    {
        self.genre = newgenre;
    }
    
    
}
