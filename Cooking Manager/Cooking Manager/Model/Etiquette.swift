

import Foundation

class Etiquette{
    
    var id :Int
    var name:String
    var author : String
    var idCategory : Int
    var ingredientList:[Ingredient]
    
    init(id:Int, name:String,author:String , idCategory:Int, ingredientList :[Ingredient]){
        self.id = id
        self.name = name
        self.author = author
        self.idCategory = idCategory
        self.ingredientList = ingredientList
    }
    
}
