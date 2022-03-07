//
//  CategoryDTO.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation

struct CategoryDTO:Codable{
    var ID_Category:Int
    var NAME:String
    var URL:String?
    init(ID_Category:Int,NAME:String,URL:String?){
        self.ID_Category = ID_Category
        self.NAME = NAME
        self.URL = URL
    }
    func DTOtoValue()->Category{
        return Category(id: self.ID_Category, name: self.NAME, url: self.URL)
    }
}
