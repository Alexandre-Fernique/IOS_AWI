
import Foundation
import Combine





enum IntentRecipeState{
    case ready
    case testValidation(Recipe)
    case updateModel
}


struct IntentRecipe{
    
    private var state = PassthroughSubject<IntentRecipeState,Never>()
   
    
    func addObserver(viewModel : RecipeVM){
        self.state.subscribe(viewModel)
    }
    

    func intentTestValidation(recipe :Recipe){
        self.state.send(.testValidation(recipe))
    }
    func intentValidation(){
        self.state.send(.updateModel)
            
        
        
    }

}

