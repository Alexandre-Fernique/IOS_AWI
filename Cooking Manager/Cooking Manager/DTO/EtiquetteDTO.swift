

import Foundation

struct EtiquetteDTO:Decodable{
    var ID_RECIPE : Int
    var NAME : String
    var AUTHOR : String
    var ID_Category : Int
    var INGREDIENT: [IngredientDTOForRecipeStep]
    init(ID_RECIPE:Int,NAME:String,AUTHOR:String,ID_Category:Int,INGREDIENT: [IngredientDTOForRecipeStep]){
        self.ID_RECIPE = ID_RECIPE
        self.NAME = NAME
        self.AUTHOR = AUTHOR
        self.ID_Category = ID_Category
        self.INGREDIENT = INGREDIENT
    }
    func DTOtoValue()->Etiquette{
        var ingredientList :[Ingredient] = []
        INGREDIENT.forEach({element in
            if let (_,ingredient) = element.DTOtoValue(){
                ingredientList.append(ingredient)
            }
        })
        return Etiquette(id: ID_RECIPE, name: NAME, author: AUTHOR, idCategory: ID_Category, ingredientList: ingredientList)
    }
}
