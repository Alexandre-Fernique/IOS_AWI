
import Foundation
import Combine

class IngredientVM:Subscriber,ObservableObject,IngredientObserver{
    func change(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentIngredientState) -> Subscribers.Demand {
        switch(input){
            
        case .ready:
            break
            
        case .updateModel:
            self.model.paste(self.copyModel)
        case .testValidation(let ingredient):
            
            self.copyModel.name = ingredient.name
            self.copyModel.unit = ingredient.unit
            self.copyModel.category = ingredient.category
            self.copyModel.unitPrice = ingredient.unitPrice
            print("\(self.copyModel.unitPrice)  \(ingredient.unitPrice)")
            if self.copyModel.unitPrice != ingredient.unitPrice {
                print("err dans le if")
                self.error = .negativeOrNullValue("le prix unitaire")
            }
            self.copyModel.stock = ingredient.stock
            if self.copyModel.stock != ingredient.stock {
                self.error = .negativeOrNullValue("le stock")
            }
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
        
    typealias Input = IntentIngredientState
    
    typealias Failure = Never
    
    func change(unitPrice: Double) {
        self.unitPrice = unitPrice
    }
    
    func change(stock: Double) {
        self.stock = stock
    }
    
    
    private var model:Ingredient
    var copyModel:Ingredient
    
    var id :Int
    @Published var name : String
    @Published var unit :Unit
    @Published var unitPrice:Double
    @Published var category:Int
    @Published var stock : Double
    @Published var allergen :Allergen?
    @Published var error : INPUTError = .noError
    
    init(model:Ingredient){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.unit = copyModel.unit
        self.unitPrice = copyModel.unitPrice
        self.category = copyModel.category
        self.stock = copyModel.stock
        self.allergen = copyModel.allergen
        self.model = model
        
        
        self.copyModel.observer = self
        
        
    }
    func getIngredientFromVM()->Ingredient{
        return Ingredient(id: id, name: name, unit: unit, unitPrice: unitPrice, category: category, stock: stock, allergen: allergen)
    }
    
    
        
}
