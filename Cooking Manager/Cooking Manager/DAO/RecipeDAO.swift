

import Foundation
struct RecipeDAO{
    var API:String
    
    init(fromApi:String){
        self.API = fromApi + "/recipe/"
    }
    
    func get(id: Int) async ->Recipe? {
        let data:Result<[StepDTOForRecipe],APIError>  = await URLSession.shared.getJSON(from: URL(string: self.API + "getRecipeById/\(id)")!)
        switch data{
            
        case .success(let DTO):
            var stepList:[Step] = []
            DTO.forEach{ element in
                stepList.append(element.DTOtoStep())
            }
            if DTO.count <= 0{
                return nil
            }
            return Recipe(recipe: DTO[0].infoRecipe(), stepList: stepList)
        case .failure(let err):
            print("Erreur : \(err)")
            return nil
        }
    }
    func create( _ recipe:Recipe) async -> Result<Int,APIError>{
        var stepList:[StepPostDTOForRecipe] = []
        
        var cpt = 0
        recipe.stepList.forEach({element in
            stepList.append(StepPostDTOForRecipe(ID: element.id, RANK: cpt))
            cpt += 1
            
        })
        
        let recipeDTO = RecipePostDTO(ID: recipe.id, NAME: recipe.name, AUTHOR: recipe.author, ID_Category: recipe.idCategory, NB_COUVERT: recipe.nbCouvert, COUT_ASSAISONNEMENT: recipe.coutAssaisonement, ISPERCENT: recipe.isPercent, STEP: stepList)
        
        return await URLSession.shared.create(from: URL(string: self.API+"createRecipe")!, element: recipeDTO)
        
        
    }
    func update( _ recipe:Recipe) async -> Result<Bool,APIError>{
        var stepList:[StepPostDTOForRecipe] = []
        
        var cpt = 0
        recipe.stepList.forEach({element in
            stepList.append(StepPostDTOForRecipe(ID: element.id, RANK: cpt))
            cpt += 1
            
        })
        let recipeDTO = RecipePostDTO(ID: recipe.id, NAME: recipe.name, AUTHOR: recipe.author, ID_Category: recipe.idCategory, NB_COUVERT: recipe.nbCouvert, COUT_ASSAISONNEMENT: recipe.coutAssaisonement, ISPERCENT: recipe.isPercent, STEP: stepList)
        return  await URLSession.shared.update(from: URL(string: self.API + "updateRecipe")!, element: recipeDTO )
        
        
    }
    func delete(_ id :Int) async -> Result<Bool,APIError>{
        
        return await URLSession.shared.delete(from: URL(string: self.API + "deleteRecipe")!, id: id)
    }
    func get() async -> [Etiquette]{
        
        let data:Result<[EtiquetteDTO],APIError> = await URLSession.shared.getJSON(from: URL(string: self.API + "getAllRecipe")!)
        
        switch data{
        case .success(let DTO):
            var etiquetteList:[Etiquette] = []
            DTO.forEach{ element in
                etiquetteList.append(element.DTOtoValue())
            }
            return etiquetteList
        case .failure(let err):
            print("Erreur : \(err)")
            return []
        }
    }
    
}

