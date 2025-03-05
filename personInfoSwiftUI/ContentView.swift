//
//  ContentView.swift
//  personInfoSwiftUI
//
//  Created by Janaka Balasooriya on 2/11/23.
//
// View

import SwiftUI


struct ContentView: View {
    @StateObject var personInfoDictionary:infoDictionary = infoDictionary()
    
    @State var author:String
    @State var genre:String
    @State var title:String
    @State var price:String
    
    @State var index:Int
    @Binding var showAddBook: Bool
    
    @State var searchauthor:String
    @State var searchgenre:String
    @State var searchprice:String
    
    @State var deleteS:String
    
    
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                NaviView(authorN: $author,titleN:$title, genreN:$genre, priceN: $price, searchtitle: "1", sauthor: $searchauthor , sgenre: $searchgenre, sprice: $searchprice, showAddBook: showAddBook, deletetitle: $deleteS, pModel: personInfoDictionary )
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-a-gradient
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color .blue]), startPoint: .leading, endPoint: .trailing
                            )
                        )
                    if let book = personInfoDictionary.getBook(index: personInfoDictionary.navIndex) {
                        VStack {
                            Text("Title: \(book.title ?? "Unknown")")
                            Text("Author: \(book.author ?? "Unknown")")
                            Text("Genre: \(book.genre ?? "Unknown")")
                            Text("Price: \(book.price ?? "Unknown")")
                        }
                    } else {
                        Text("Preview Unavailable, Please add your first book")
                        
                    }
                }
                .padding(20)
                .frame(width: 337.5, height: 600)

                Spacer()
                ToolView(searchtitle: "1", authorN: $author,titleN:$title, genreN:$genre, priceN: $price, sauthor: $searchauthor , sgenre: $searchgenre, pModel: personInfoDictionary)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Person Info")
            
            
        }
    }
}


struct NaviView: View
{
    @Binding var authorN:String
    @Binding var titleN:String
    @Binding var genreN:String
    @Binding var priceN:String
    
    @State  var searchtitle: String
    
    @Binding var sauthor: String
    @Binding var sgenre:String
    @Binding var sprice:String
    
    @State  var showingSearchAlert = false
    @State  var showingSearchForm = false
    @State var showAddBook: Bool
    @State var showFoundAlert: Bool = false
    
    @State  var showingDeleteAlert = false
    @Binding  var deletetitle: String
    @ObservedObject  var pModel : infoDictionary
    
    var body: some View
    {
        Text("")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingSearchForm = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .scaledToFit()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action:
                            {
                        print(authorN)
                        showingDeleteAlert = true
                    },
                           label: {
                        Image(systemName: "trash")
                    })
                }
            }.alert("Delete Record", isPresented: $showingDeleteAlert, actions: {
                TextField("Enter title", text: $deletetitle)
                
                Button("Delete", action: {
                    
                    let title = String(deletetitle)
                    pModel.deleteRec(s:title)
                    showingDeleteAlert = false
                    
                })
                Button("Cancel", role: .cancel, action: {
                    showingDeleteAlert = false
                })
            }, message: {
                Text("Please enter title to Search.")
            })
            .sheet(isPresented: $showingSearchForm) {
                Form {
                    Section(header: Text("Search Book")) {
                        TextField("Type your Book Title", text: $searchtitle)
                        
                        Button("Search") {
                            let title = searchtitle
                            if let p = pModel.search(s: title) {
                                sauthor = p.author ?? "Unknown"
                                sgenre = p.genre ?? "Unknown"
                                sprice = p.price ?? "Unknown"
                                showFoundAlert = true
                                print("In search")
                            } else {
                                sauthor = "No Record"
                                sgenre = "No Record"
                                sprice = "No Record"
                                showFoundAlert = false
                                print("No Record")
                                
                            }
                        }
                        
                        Text("You need to search book first!")
                        
                        Button("Cancel") {
                            showingSearchForm = false
                        }
                        
                    }
                    
                    Section(header: Text("Search result")) {
                        TextField("Title", text: $searchtitle)
                        TextField("Author", text: $sauthor)
                        TextField("Genre", text: $sgenre)
                        TextField("Price", text: $sprice)
                        
                        Button("Update") {
                            if let p = pModel.search(s: searchtitle) {
                                p.author = sauthor
                                p.genre = sgenre
                                p.price = sprice
                                p.title = searchtitle
                                pModel.navIndex += 0
                            }
                        }
                        
                    }
                    
                }
                .alert(isPresented: $showFoundAlert) {
                                Alert(title: Text("Message"), message: Text("We found the book! You may edit the book now!"), dismissButton: .default(Text("OK")))
                            }
            }
    }
}

struct ToolView: View
{
    @State  var searchtitle: String
    @Binding var authorN:String
    @Binding var titleN:String
    @Binding var genreN:String
    @Binding var priceN:String
    @State var showAddBook: Bool = false
    
    @Binding var sauthor: String
    @Binding var sgenre:String
    @ObservedObject  var pModel : infoDictionary
    
    @State private var showEndAlert: Bool = false
    @State private var endAlertMessage: String = ""
    
    // @State  var showingNoRecordsFoundDialog = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("")
                
                // Toolbar
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            Button("Next") {
                                if pModel.navIndex < pModel.getCount() - 1 {
                                    pModel.navIndex += 1
                                } else {
                                    endAlertMessage = "No next book available"
                                    showEndAlert = true
                                }
                            }
                            
                            Spacer()
                            Button("Prev") {
                                if pModel.navIndex > 0 {
                                    pModel.navIndex -= 1
                                } else {
                                    endAlertMessage = "No previous book available"
                                    showEndAlert = true
                                }
                            }
                            
                            Spacer()
                        }
                        
                        ToolbarItem(placement: .bottomBar) {
                            Button(action:
                                    {
                                print(pModel.getCount())
                                showAddBook = true
                            },
                                   label: {
                                Image(systemName: "plus.app")
                            })
                        }
                    }
                    .sheet(isPresented: $showAddBook, content: {
                        dataEnterView(authorD: $authorN, titleD: $titleN, genreD: $genreN, priceD: $priceN, showAddBook: $showAddBook, pModel: self.pModel)
                        
                    })
                
            }
            .alert(isPresented: $showEndAlert) {
                            Alert(title: Text("Opps"), message: Text(endAlertMessage), dismissButton: .default(Text("OK")))
                        }
        }
    }
}




struct dataEnterView: View
{
    @Binding var authorD:String
    @Binding var titleD:String
    @Binding var genreD:String
    @Binding var priceD:String
    @Binding var showAddBook:Bool
    @ObservedObject  var pModel : infoDictionary
    
    var body: some View
    {
        VStack{
            Button("save", action:{
                pModel.add(authorD, titleD, genreD, priceD)
                showAddBook = false
            })
        }
        HStack{
            
            Text("title:")
                .foregroundColor(.blue)
            Spacer()
            TextField("Enter title", text: $titleD)
                .textFieldStyle(.roundedBorder)
            
        }
        
        HStack{
            
            Text("author:")
                .foregroundColor(.blue)
            Spacer()
            TextField("Enter author", text: $authorD)
                .textFieldStyle(.roundedBorder)
            
        }
        
        HStack{
            
            Text("genre:")
                .foregroundColor(.blue)
            Spacer()
            TextField("Enter genre", text: $genreD)
                .textFieldStyle(.roundedBorder)
            
        }
        
        HStack{
            
            Text("price:")
                .foregroundColor(.blue)
            Spacer()
            TextField("Enter price", text: $priceD)
                .textFieldStyle(.roundedBorder)
            
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(author: "janaka", genre: "10", title: "1", price: "5.00", index: 2, showAddBook: .constant(false), searchauthor: "", searchgenre: "", searchprice: "5.00", deleteS: "")
    }
}
