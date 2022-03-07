//
//  Cooking_ManagerApp.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI

@main
struct Cooking_ManagerApp: App {
    init(){
        APIservice.API = "https://back-cooking-management.herokuapp.com"
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


