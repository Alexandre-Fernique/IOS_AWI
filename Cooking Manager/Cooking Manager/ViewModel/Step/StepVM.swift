

import Foundation
import Combine

class StepVM:Subscriber,ObservableObject,StepObserver{
    func change(duration: Int) {
        self.duration = duration
    }
    typealias Input = IntentStepState

    typealias Failure = Never
    func receive(_ input: IntentStepState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .updateModel:
            self.model.paste(copyModel)
        case .testValidation(let step):
            self.copyModel.name = step.name
            self.copyModel.description = step.description
            self.copyModel.ingredient = step.ingredient
            self.copyModel.duration = step.duration
            if self.copyModel.duration != step.duration {
                error = .negativeOrNullValue("la durée")
            }
        }
        return .none
    }
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    private var model:Step
    var copyModel:Step
    var id :Int
    @Published var name : String
    @Published var description:String
    @Published var duration: Int
    @Published var ingredient: [IngredientQuantity]
    @Published var error : INPUTError = .noError

    init(model:Step){
        self.copyModel = model.copy()
        self.id = copyModel.id
        self.name = copyModel.name
        self.description = copyModel.description
        self.duration = copyModel.duration
        self.ingredient = copyModel.ingredient
        self.model = model
        self.copyModel.observer = self
    }
    func getStep()->Step{
        return Step(id: self.id, name: self.name, description: self.description, duration: self.duration, ingredient: self.ingredient)
    }
}
    
        
