//
//  AllergenDTO.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation
struct AllergenDTO:Codable{
    var ID:Int?
    var NAME:String?
    var ID_Category:Int?
    var URL:String?
    init(ID:Int?,NAME:String?,ID_Category:Int?,URL:String?){
        self.ID = ID
        self.NAME = NAME
        self.ID_Category = ID_Category
        self.URL = URL
    }
    func DTOtoValue()->Allergen?{
        guard let ID = self.ID else {
            return nil
        }
        return Allergen(id: ID, name: self.NAME!, idCategory: ID_Category!, url:Foundation.URL(string:URL!)!)

        
    }
}
