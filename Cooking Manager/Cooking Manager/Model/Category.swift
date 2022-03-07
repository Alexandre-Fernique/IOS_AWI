//
//  Category.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class Category:Hashable{
    static func == (lhs: Category, rhs: Category) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    var id:Int
    var name:String
    var url:String?
    init(id:Int,name:String,url:String?){
        self.id = id
        self.name = name
        self.url = url
    }
}
