

import Foundation
import Combine
class AllergensVM:ObservableObject,Subscriber{
    typealias Input = IntentListState<Allergen>
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentListState<Allergen>) -> Subscribers.Demand {
        switch(input){
            
        case .upToDate:
            break
            
        case .listUpdated:
            self.objectWillChange.send()
            
        case .deleteRequest(let id):
            self.allergens.removeAll(where: {
                element in
                return element.id == id
            })
            textAlert = "Allergène supprimé"
            alert = true
            
        case .createRequest(let allergen):
            self.allergens.append(allergen)
            textAlert = "Allergène créé"
            alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    
    
    @Published var allergens : [Allergen]
    @Published var textAlert = ""
    @Published var alert = false
    
    init(allergens : [Allergen]){
        self.allergens = allergens
    }
    
    
    
    
    
}

