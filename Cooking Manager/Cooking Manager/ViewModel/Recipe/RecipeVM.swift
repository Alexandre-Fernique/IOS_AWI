
import Foundation
import Combine

class RecipeVM:Subscriber,ObservableObject{
    
    typealias Input = IntentRecipeState

    typealias Failure = Never
    func receive(_ input: IntentRecipeState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
      
        case .updateModel:
            break
        case .testValidation(let recipe):
            self.model.name = recipe.name
            self.model.author = recipe.author
            self.model.idCategory = recipe.idCategory
            self.model.stepList = recipe.stepList
            self.model.nbCouvert = recipe.nbCouvert
        }
        return .none
    }
    
    
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    
    var model:Recipe
    
    
    var id :Int
    @Published var name : String
    @Published var author:String
    @Published var nbCouvert: Int
    @Published var idCategory : Int
    @Published var stepList:[Step]
    @Published var error : INPUTError = .noError
    
    init(model:Recipe){
        self.id = model.id
        self.name = model.name
        self.author = model.author
        self.nbCouvert = model.nbCouvert
        self.idCategory = model.idCategory
        self.stepList = model.stepList
        self.model = model
    }
    func getRecipe()->Recipe{
        return Recipe(id: id, name: name, author: author, idCategory: idCategory, nbCouvert: nbCouvert, coutAssaisonement: model.coutAssaisonement, isPercent: model.isPercent, stepList: stepList)
    }
    
}
    
        

