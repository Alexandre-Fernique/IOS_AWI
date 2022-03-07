

import Foundation
class IngredientQuantity:Identifiable{
   
    var ingredient:Ingredient
    var quantity:Double
    init(ingredient:Ingredient,quantity:Double){
        self.ingredient = ingredient
        self.quantity = quantity
    }
    init(){
        self.ingredient = Ingredient(id: 0, name: "", unit: .Kg, unitPrice: 0, category: 0, stock: 0, allergen: nil)
        self.quantity = 0
    }
}
