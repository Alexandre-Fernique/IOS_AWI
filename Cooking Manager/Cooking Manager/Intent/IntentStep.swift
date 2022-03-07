

import Foundation
import Combine
import SwiftUI




enum IntentStepState{
    case ready
    case testValidation(Step)
    case updateModel
}


struct IntentStep{
    
    private var state = PassthroughSubject<IntentStepState,Never>()
    private var listState = PassthroughSubject<IntentListState<Step>,Never>()
    
    func addObserver(viewModel : StepVM){
        self.state.subscribe(viewModel)
    }
    
    func addListObserver(viewModel : StepsVM){
        self.listState.subscribe(viewModel)
    }
    
    
    func intentDeleteRequest(id:Int) async ->Result<Bool,APIError>{
        let data = await APIservice.stepDAO().delete(id)
        switch data{
        case .success(_):
            self.listState.send(.deleteRequest(id))
            return data
        case .failure(_):
            return data
        }
    }
    func intentCreateRequest(element:Step) async->Result<Bool,APIError> {
        let data = await APIservice.stepDAO().create(element)
        switch data{
            case .success(let id):
            element.id = id
            self.listState.send(.createRequest(element))
            return .success(true)
        case .failure(let err):
            return .failure(err)
            
        }
        
        
    }

    func intentTestValidation(step :Step){
        self.state.send(.testValidation(step))
    }
    func intentValidation(step:Step) async ->Result<Bool,APIError>{
        let data = await APIservice.stepDAO().update(step)
        switch data{
            case .success(_):
            self.state.send(.updateModel)
            self.listState.send(.listUpdated)
        
            return.success(true)
            
        
        case .failure(let err):
            return .failure(err)
            
        }
            
    }
}

