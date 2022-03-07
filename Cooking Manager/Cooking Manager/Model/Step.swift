
import Foundation
protocol StepObserver{
    func change(duration:Int)
    
}
class Step:Identifiable{
    var observer : StepObserver?
    var id:Int
    var name:String
    var description :String
    var duration:Int{
        didSet{
            if self.duration <= 0{
                self.duration = oldValue
                observer?.change(duration: self.duration)
            }
        }
    }
    var ingredient:[IngredientQuantity]
    
    init(id:Int,name:String,description:String,duration:Int,ingredient:[IngredientQuantity]){
        self.id = id
        self.name = name
        self.description = description
        self.duration = duration
        self.ingredient = ingredient
    }
    func getDuration()->String{
        if duration >= 60 {
            return "\(duration/60)h\(duration%60)"
        }
        else{
            return "\(duration)m"
        }
    }
    func copy()->Step{
        
        let ingreQCopyt = self.ingredient.map({
            IngredientQuantity(ingredient: $0.ingredient.copy(), quantity: $0.quantity)
        })
        
        return Step(id: self.id, name: self.name, description: self.description, duration: self.duration, ingredient: ingreQCopyt)
    }
    func paste(_ step:Step){
        self.id = step.id
        self.name = step.name
        self.description = step.description
        self.duration = step.duration
        self.ingredient = step.ingredient
    }
    func getCout()->Double{
        var sum :Double = 0
        ingredient.forEach({element in
            sum += element.quantity * element.ingredient.unitPrice
            
        })
        return sum
    }
}

