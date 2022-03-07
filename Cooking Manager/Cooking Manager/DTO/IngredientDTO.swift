import Foundation

struct IngredientDTO:Codable{
    var ID:Int
    var NAME:String
    var UNIT :String
    var UNIT_PRICE:Double
    var ID_Category:Int
    var STOCK : Double
    var ALLERGEN :AllergenDTO
    init(ID:Int,NAME:String,UNIT:String,UNIT_PRICE:Double,ID_Category:Int,STOCK:Double,ALLERGEN:AllergenDTO){
        self.ID = ID
        self.NAME = NAME
        self.UNIT = UNIT
        self.UNIT_PRICE = UNIT_PRICE
        self.ID_Category = ID_Category
        self.STOCK = STOCK
        self.ALLERGEN = ALLERGEN
        
    }
    func DTOtoValue()->Ingredient?{
        var unit :Unit
        switch(UNIT){
        case "Kg":unit = .Kg
        case "L": unit = .L
        case "Botte": unit = .Botte
        case "P": unit = .P
        case "U": unit = .U
        default: unit = .unknow
            
        }
        
        guard let allergen = ALLERGEN.DTOtoValue() else{
            return Ingredient(id: ID, name: NAME, unit: unit, unitPrice: UNIT_PRICE, category:ID_Category, stock: STOCK, allergen: nil)
        }
        return Ingredient(id: ID, name: NAME, unit: unit, unitPrice: UNIT_PRICE, category: ID_Category, stock: STOCK, allergen: allergen)
    }
    
}
struct IngredientDTOPOST:Encodable{
    var ID:Int
    var NAME:String
    var UNIT :String
    var UNIT_PRICE:Double
    var ID_Category:Int
    var STOCK : Double
    var ALLERGEN :Int?
    init(ID:Int,NAME:String,UNIT:String,UNIT_PRICE:Double,ID_Category:Int,STOCK:Double,ALLERGEN:Int?){
        self.ID = ID
        self.NAME = NAME
        self.UNIT = UNIT
        self.UNIT_PRICE = UNIT_PRICE
        self.ID_Category = ID_Category
        self.STOCK = STOCK
        self.ALLERGEN = ALLERGEN
        
    }
    
}
struct IngredientDTOForRecipeStep:Codable{
    var ID:Int?
    var NAME:String?
    var UNIT :String?
    var UNIT_PRICE:Double?
    var ID_Category:Int?
    var STOCK : Double?
    var QUANTITY: Double?
    var ALLERGEN :AllergenDTO
    init(ID:Int,NAME:String,UNIT:String,UNIT_PRICE:Double,ID_Category:Int,STOCK:Double,ALLERGEN:AllergenDTO,QUANTITY: Double){
        self.ID = ID
        self.NAME = NAME
        self.UNIT = UNIT
        self.UNIT_PRICE = UNIT_PRICE
        self.ID_Category = ID_Category
        self.STOCK = STOCK
        self.ALLERGEN = ALLERGEN
        self.QUANTITY = QUANTITY
        
    }
    func DTOtoValue()->(Double,Ingredient)?{
        var unit :Unit
        switch(UNIT){
        case "Kg":unit = .Kg
        case "L": unit = .L
        case "Botte": unit = .Botte
        case "P": unit = .P
        case "U": unit = .U
        default: unit = .unknow
            
        }
        guard let _ = ID else{
            return nil
        }
        guard let allergen = ALLERGEN.DTOtoValue() else{
            return (QUANTITY!,Ingredient(id: ID!, name: NAME!, unit: unit, unitPrice: UNIT_PRICE!, category:ID_Category!, stock: STOCK!, allergen: nil))
        }
        return (QUANTITY!,Ingredient(id: ID!, name: NAME!, unit: unit, unitPrice: UNIT_PRICE!, category: ID_Category!, stock: STOCK!, allergen: allergen))
    }
    
}
