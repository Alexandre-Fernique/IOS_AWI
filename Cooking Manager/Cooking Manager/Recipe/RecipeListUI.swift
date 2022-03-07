//
//  RecipeListUI.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI

struct RecipeListUI: View {
    @State var etiquetteList:[Etiquette] = []
    @State var dataIsLoad = false
    @State private var searchText = ""
    @State var categoryList:[Category] = []
    @State private var createRecipe = false
    private var searchResults:[Etiquette]{
        if searchText.isEmpty {
            return etiquetteList
        } else {
            return etiquetteList.filter { $0.name.uppercased().contains(searchText.uppercased()) || $0.ingredientList.contains(where: {$0.name.uppercased().contains(searchText.uppercased())}) }
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination:RecipeCreateUI(),isActive: $createRecipe){}
                    List{
                        ForEach(categoryList,id:\.id){
                            category in
                            Section(category.name)
                            {
                                ForEach(searchResults,id:\.id){
                                    etiquette in
                                    if( etiquette.idCategory == category.id){
                                        NavigationLink(destination:RecipeDetailUI(etiquette: etiquette)){
                                            VStack( alignment: .leading ){
                                                Text(etiquette.name)
                                                Text("Ingredient :").opacity(0.5).font(.system(size: 15))
                                                ForEach(etiquette.ingredientList,id:\.id){ingredient in
                                                    Text(ingredient.name).opacity(0.5).font(.system(size: 15))
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }.searchable(text: $searchText)
                    .onAppear(){
                        loadData()
                        
                    }.toolbar{
                        Button("+") {
                            createRecipe = true
                            
                        }
                    }.navigationTitle("Recette")
                }
                
                
                        
                }.overlay(Group{
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            })
            
        }
    }
    func loadData(){
        Task{
            self.etiquetteList = await APIservice.recipeDAO().get()
            
        }
        Task{
            self.categoryList = await APIservice.categoryDAO().getCategory(type: .recipe)
            dataIsLoad = true
        }
        
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListUI()
    }
}
