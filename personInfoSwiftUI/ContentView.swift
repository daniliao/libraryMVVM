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
                    if let title = personInfoDictionary.getFirstAvailableBook() {
                        Text("Title: \(title)")
                    } else {
                        VStack{
                            Text("Preview Unavailable")
                            Text("Please add your first book")
                        }
                    }
                }
                .padding(20)
                .frame(width: 337.5, height: 212.5)
                
                
                
                //Spacer()
                //Text("Search Results")
                //Spacer()
                //SearchView(authorS: $searchauthor, genreS: $searchgenre)
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
                                print("In search")
                            } else {
                                sauthor = "No Record"
                                sgenre = "No Record"
                                sprice = "No Record"
                                print("No Record")
                            }
                        }
                        
                        Button("Cancel") {
                            showingSearchForm = false
                        }
                        
                    }
                    
                    Section(header: Text("Search result")) {
                        Text(searchtitle)
                        
                        Text(sauthor)
                        
                        Text(sgenre)
                        
                        Text(sprice)
                        
                    }
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
                            // Implement navigation action
                        }
                        Spacer()
                        Button("Prev") {
                            // Implement navigation action
                        }
                        Spacer()
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button(action:
                                {
                            print(pModel.getCount())
                            showAddBook = true
                            // pModel.add(authorN, String(titleN), String(genreN), String(priceN))
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

struct SearchView: View
{
    
    @Binding var authorS:String
    @Binding var genreS:String
    @ObservedObject  var pModel : infoDictionary
    
    var body: some View
    {
        HStack{
            Text("author:")
                .foregroundColor(.blue)
            Spacer()
            TextField("", text: $authorS)
                .textFieldStyle(.roundedBorder)
                
        }
        
        
        HStack{
            Text("genre:")
                .foregroundColor(.blue)
            Spacer()
            TextField("", text: $genreS)
                .textFieldStyle(.roundedBorder)
                
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(author: "janaka", genre: "10", title: "1", price: "5.00", index: 2, showAddBook: .constant(false), searchauthor: "", searchgenre: "", searchprice: "5.00", deleteS: "")
    }
}
