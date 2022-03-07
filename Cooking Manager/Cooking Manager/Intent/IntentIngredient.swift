//
//  IntentIngredient.swift
//  Cooking Manager
//
//  Created by m1 on 23/02/2022.
//

import Foundation
import Combine
import SwiftUI





enum IntentIngredientState{
    case ready
    case testValidation(Ingredient)
    case updateModel
}


struct IntentIngredient{
    
    private var state = PassthroughSubject<IntentIngredientState,Never>()
    private var listState = PassthroughSubject<IntentListState<Ingredient>,Never>()
    
    func addObserver(viewModel : IngredientVM){
        self.state.subscribe(viewModel)
    }
    
    func addListObserver(viewModel : IngredientsVM){
        self.listState.subscribe(viewModel)
    }
    
    
    func intentDeleteRequest(id:Int) async ->Result<Bool,APIError>{
        let data = await APIservice.ingredientDAO().delete(id)
        switch data{
        case .success(_):
            self.listState.send(.deleteRequest(id))
            return data
        case .failure(_):
            return data
        }
    }
    func intentCreateRequest(element:Ingredient) {
        self.listState.send(.createRequest(element))
        
    }
    func intentTestValidation(ingredient :Ingredient){
        self.state.send(.testValidation(ingredient))
    }
    
    func intentValidation(ingredient:Ingredient)async ->Result<Bool,APIError>{
        let data = await APIservice.ingredientDAO().update(ingredient)
        switch data {
            case .success(_):
            
            self.state.send(.updateModel)
            self.listState.send(.listUpdated)
            return .success(true)
        case .failure(let err):
            return .failure(err)
        }
        
            
    }

}

