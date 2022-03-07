
import Foundation
import Combine
import SwiftUI




enum IntentAllergenState{
    case ready
    case testValidation(Allergen)
    case updateModel
}


struct IntentAllergen{
    
    private var state = PassthroughSubject<IntentAllergenState,Never>()
    private var listState = PassthroughSubject<IntentListState<Allergen>,Never>()
    
    func addObserver(viewModel : AllergenVM){
        self.state.subscribe(viewModel)
    }
    
    func addListObserver(viewModel : AllergensVM){
        self.listState.subscribe(viewModel)
    }
    
    
    func intentDeleteRequest(id:Int) async ->Result<Bool,APIError>{
        let data = await APIservice.allergenDAO().delete(id)
        switch data{
        case .success(_):
            self.listState.send(.deleteRequest(id))
            return data
        case .failure(_):
            return data
        }
    }
    func intentCreateRequest(element:Allergen) async ->Result<Bool,APIError> {
        let data = await APIservice.allergenDAO().create(element)
        switch data{
            case .success(let id):
            element.id = id
            self.listState.send(.createRequest(element))
            return .success(true)
        case .failure(let err):
            return .failure(err)
            
        }
        
    }
    
    func intentTestValidation(allergen :Allergen){
        self.state.send(.testValidation(allergen))
    }
    func intentValidation(allergen:Allergen) async->Result<Bool,APIError>{
        let data = await APIservice.allergenDAO().update(allergen)
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

