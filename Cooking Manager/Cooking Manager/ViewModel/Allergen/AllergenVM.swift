
import Foundation
import Combine

class AllergenVM:Subscriber,ObservableObject{
    
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentAllergenState) -> Subscribers.Demand {
        switch(input){
            
        case .ready:
            break
        
        case .updateModel:
            self.model.paste(self.copyModel)
        
        
            
        case .testValidation(let allergen):
            self.copyModel.name = allergen.name
            self.copyModel.idCategory = allergen.idCategory
            self.copyModel.url = allergen.url
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
        
    typealias Input = IntentAllergenState
    
    typealias Failure = Never
    
    
    private var model:Allergen
    var copyModel:Allergen
    
    var id :Int
    @Published var name : String
    @Published var idCategory:Int
    @Published var url: URL
    @Published var error : INPUTError = .noError
    
    init(model:Allergen){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.idCategory = copyModel.idCategory
        self.url = copyModel.url
        self.model = model
        
        
    }
    func getAllergen()->Allergen{
        return Allergen(id: id, name: name, idCategory: idCategory, url: url)
    }
        
}
