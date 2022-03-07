

import Foundation
import SwiftUI

struct StepDTO:Codable{
    var ID_STEP:Int
    var NAME:String
    var DESCRIPTION :String
    var DURATION:Int
    var INGREDIENT:[IngredientDTOForRecipeStep]
    
    
    init(ID_STEP:Int,NAME:String,DESCRIPTION:String,DURATION:Int,INGREDIENT:[IngredientDTOForRecipeStep]){
        self.ID_STEP = ID_STEP
        self.NAME = NAME
        self.DESCRIPTION = DESCRIPTION
        self.DURATION = DURATION
        self.INGREDIENT = INGREDIENT
  
        
    }
    func DTOtoValue()->Step{
        var ingredientList :[IngredientQuantity] = []
        INGREDIENT.forEach({element in
            if let (qty,ingre) = element.DTOtoValue(){
                ingredientList.append(IngredientQuantity(ingredient: ingre, quantity: qty))
            }
        })
        
        return Step(id: ID_STEP, name: NAME, description: DESCRIPTION, duration: DURATION, ingredient: ingredientList)
    }
    
}
struct StepDTOPOST:Encodable{
    var ID:Int
    var NAME:String
    var DESCRIPTION :String
    var DURATION:Int
    var INGREDIENT:[IngredientForStepDTOPOST]
    
    init(ID:Int,NAME:String,DESCRIPTION:String,DURATION:Int,INGREDIENT:[IngredientForStepDTOPOST]){
        self.ID = ID
        self.NAME = NAME
        self.DESCRIPTION = DESCRIPTION
        self.DURATION = DURATION
        self.INGREDIENT = INGREDIENT
        
    }
    
}
struct IngredientForStepDTOPOST:Encodable{
    var ID:Int
    var QUANTITY:Double
    init(ID:Int,QUANTITY:Double){
        self.ID = ID
        self.QUANTITY = QUANTITY
    }
}

struct StepDTOForRecipe:Decodable{
   
    var ID_RECIPE: Int
    var NAMER : String
    var AUTHOR :String
    var ID_Category : Int
    var NB_COUVERT : Int
    var COUT_ASSAISONNEMENT : Double
    var ISPERCENT : Int
    var ID_STEP : Int
    var NAMES : String
    var DESCRIPTION : String
    var DURATION : Int
    var INGREDIENT : [IngredientDTOForRecipeStep]
    init(ID_RECIPE: Int,NAMER : String,AUTHOR :String,ID_Category : Int,NB_COUVERT : Int,COUT_ASSAISONNEMENT : Double,ISPERCENT : Int,ID_STEP : Int,NAMES : String,DESCRIPTION : String,DURATION : Int,INGREDIENT : [IngredientDTOForRecipeStep]){
        self.ID_RECIPE = ID_RECIPE
        self.NAMER = NAMER
        self.AUTHOR = AUTHOR
        self.ID_Category = ID_Category
        self.NB_COUVERT = NB_COUVERT
        self.COUT_ASSAISONNEMENT = COUT_ASSAISONNEMENT
        self.ISPERCENT = ISPERCENT
        self.ID_STEP = ID_STEP
        self.NAMES = NAMES
        self.DESCRIPTION = DESCRIPTION
        self.DURATION = DURATION
        self.INGREDIENT = INGREDIENT
    }
    func DTOtoStep()->Step{
        var ingredientList :[IngredientQuantity] = []
        INGREDIENT.forEach({element in
            if let (qty,ingre) = element.DTOtoValue(){
                ingredientList.append(IngredientQuantity(ingredient: ingre, quantity: qty))
            }
        })
        return Step(id: ID_STEP, name: NAMES, description: DESCRIPTION, duration: DURATION, ingredient: ingredientList)
    
    }
    func infoRecipe()->Recipe{
        return Recipe(id: ID_RECIPE, name: NAMER, author: AUTHOR, idCategory: ID_Category, nbCouvert: NB_COUVERT, coutAssaisonement: COUT_ASSAISONNEMENT, isPercent: ISPERCENT, stepList: [])
    }
        
}



struct StepPostDTOForRecipe:Encodable{
    let TYPE = "STEP"
    var ID :Int
    var RANK : Int
    init(ID:Int,RANK:Int){
        self.ID = ID
        self.RANK = RANK
    }
}

