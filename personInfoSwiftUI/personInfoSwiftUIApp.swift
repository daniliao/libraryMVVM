//
//  personInfoSwiftUIApp.swift
//  personInfoSwiftUI
//
//  Created by Janaka Balasooriya on 2/11/23.
//

import SwiftUI

@main
struct personInfoSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(author: "Janaka", genre: "10", title: "1", price: "5.00", index: 2, showAddBook: .constant(false), searchauthor: "", searchgenre: "", searchprice: "5.00", deleteS: "")
        }
    }
}
