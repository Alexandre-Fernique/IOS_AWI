//
//  ContentView.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            RecipeListUI().tabItem {Label("Recette",systemImage: "applescript") }.tag(1)
            StepListUI().tabItem {Label("Etape",systemImage: "list.dash") }.tag(2)
            IngredientListUI().tabItem { Label("Ingrédient", systemImage: "leaf") }.tag(3)
            AllergenListUI().tabItem{
                Label("Allergène", systemImage: "allergens")
            }.tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
