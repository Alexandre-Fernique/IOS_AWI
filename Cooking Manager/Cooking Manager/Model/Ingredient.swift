

import Foundation



protocol IngredientObserver{
    func change(name:String)
    func change(unitPrice:Double)
    func change(stock:Double)
    
}
class Ingredient{
    
    var observer:IngredientObserver?
    var id:Int
    var name:String{
        didSet{
            if self.name == "" {
                self.name = oldValue
                observer?.change(name: self.name)
            }
        }
    }
    var unit :Unit
    var unitPrice:Double{
        didSet{
            if self.unitPrice <= 0 {
                self.unitPrice = oldValue
                observer?.change(unitPrice: self.unitPrice)
            }
            
        }
    }
    var category:Int
    var stock : Double{
        didSet{
            if self.stock <= 0 {
                self.stock = oldValue
                observer?.change(stock: self.stock)
            }
            
        }
    }
    var allergen :Allergen?
    init(id:Int,name:String,unit:Unit,unitPrice:Double,category:Int,stock:Double,allergen:Allergen?){
        self.id = id
        self.name = name
        self.unit = unit
        self.unitPrice = unitPrice
        self.category = category
        self.stock = stock
        self.allergen = allergen
        
    }
    func copy()->Ingredient{
        return Ingredient(id: self.id, name: self.name, unit: self.unit, unitPrice: self.unitPrice, category: self.category, stock: self.stock, allergen: self.allergen)
    }
    func paste(_ ingredient:Ingredient){
        self.id = ingredient.id
        self.name = ingredient.name
        self.unit = ingredient.unit
        self.unitPrice = ingredient.unitPrice
        self.category = ingredient.category
        self.stock = ingredient.stock
        self.allergen = ingredient.allergen
    }
    
}
