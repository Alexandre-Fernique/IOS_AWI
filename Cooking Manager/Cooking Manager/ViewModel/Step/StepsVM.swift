

import Foundation
import Combine
class StepsVM:ObservableObject,Subscriber{
    typealias Input = IntentListState<Step>
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentListState<Step>) -> Subscribers.Demand {
        switch(input){
            
        case .upToDate:
            break
            
        case .listUpdated:
            self.objectWillChange.send()
            
        case .deleteRequest(let id):
            self.steps.removeAll(where: {
                element in
                return element.id == id
            })
            textAlert = "Étape supprimée"
            alert = true
            
        case .createRequest(let allergen):
            self.steps.append(allergen)
            textAlert = "Étape créée"
            alert = true
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    @Published var steps : [Step]
    @Published var alert = false
    @Published var textAlert = ""
    
    init(steps : [Step]){
        self.steps = steps
    }
    
    
    
    
    
}

