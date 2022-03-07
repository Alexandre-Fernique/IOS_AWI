//
//  Allergen.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation
import SwiftUI


class Allergen:Hashable{
    static func == (lhs: Allergen, rhs: Allergen) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
    var id:Int
    var name:String
    var idCategory:Int
    var url:URL
    init(id:Int,name:String,idCategory:Int,url:URL){
        self.id = id
        self.name = name
        self.idCategory = idCategory
        self.url = url
    }
    func copy()->Allergen{
        return Allergen(id: self.id, name: self.name, idCategory: self.idCategory, url: self.url)
    }
    
    func paste(_ allergen:Allergen){
        self.id = allergen.id
        self.name = allergen.name
        self.idCategory = allergen.idCategory
        self.url = allergen.url
    }
}
