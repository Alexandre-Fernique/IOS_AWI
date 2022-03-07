

import Foundation
import Combine
class IngredientsVM:ObservableObject,Subscriber{
    typealias Input = IntentListState<Ingredient>
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentListState<Ingredient>) -> Subscribers.Demand {
        switch(input){
            
        case .upToDate:
            break
            
        case .listUpdated:
            self.objectWillChange.send()
            
        case .deleteRequest(let id):
            self.ingredients.removeAll(where: {
                element in
                return element.id == id
            })
            self.textAlert = "Ingrédient supprimé"
            self.alert = true
            
            
        case .createRequest(let ingredient):
            self.ingredients.append(ingredient)
            self.textAlert = "Ingrédient créé"
            self.alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    
    @Published var ingredients : [Ingredient];
    @Published var categoryIngredient:[Category] = []
    @Published var alert = false
    @Published var textAlert = ""
    
    init(ingredients : [Ingredient]){
        self.ingredients = ingredients
    }
    
    
    
    
    
    
}

