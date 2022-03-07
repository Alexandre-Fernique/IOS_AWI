

import Foundation
struct StepDAO{
    var API:String
    
    init(fromApi:String){
        self.API = fromApi + "/step/"
    }
    
    func get() async ->[Step] {
        let data:Result<[StepDTO],APIError>  = await URLSession.shared.getJSON(from: URL(string: self.API + "getStep")!)
        switch data{
            
        case .success(let DTO):
            var stepList:[Step] = []
            DTO.forEach{ element in
                stepList.append(element.DTOtoValue())
            }
            return stepList
        case .failure(let err):
            print("Erreur : \(err)")
            return []
        }
    }
    func create( _ step:Step) async -> Result<Int,APIError>{
        var idIngredientQuantity:[IngredientForStepDTOPOST] = []
        step.ingredient.forEach({element in
            idIngredientQuantity.append(IngredientForStepDTOPOST(ID: element.ingredient.id , QUANTITY: element.quantity))
            
        })
        let stepDTO = StepDTOPOST(ID: step.id, NAME: step.name, DESCRIPTION: step.description, DURATION: step.duration, INGREDIENT: idIngredientQuantity)
        
        return await URLSession.shared.create(from: URL(string: self.API+"createStep")!, element: stepDTO)
        
        
    }
    func update( _ step:Step) async -> Result<Bool,APIError>{
        var idIngredientQuantity:[IngredientForStepDTOPOST] = []
        step.ingredient.forEach({element in
            idIngredientQuantity.append(IngredientForStepDTOPOST(ID: element.ingredient.id , QUANTITY: element.quantity))
            
        })
        let stepDTO = StepDTOPOST(ID: step.id, NAME: step.name, DESCRIPTION: step.description, DURATION: step.duration, INGREDIENT: idIngredientQuantity)
        
        return  await URLSession.shared.update(from: URL(string: self.API + "updateStep")!, element: stepDTO )
        
        
    }
    func delete(_ id :Int) async -> Result<Bool,APIError>{
        
        return await URLSession.shared.delete(from: URL(string: self.API + "deleteStep")!, id: id)
    }
    
}
