//
//  IngredientDAO.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation

struct IngredientDAO{
    var API:String
    
    init(fromApi:String){
        self.API = fromApi + "/ingredient/"
    }
    
    func getIngredient() async ->[Ingredient] {
        let data:Result<[IngredientDTO],APIError>  = await URLSession.shared.getJSON(from: URL(string: self.API + "getIngredientIOS")!)
        switch data{
            
        case .success(let DTO):
            var ingredientList:[Ingredient] = []
            DTO.forEach{ element in
                if let notNilElment = element.DTOtoValue(){
                    ingredientList.append(notNilElment)
                }
                
            }
            return ingredientList
        case .failure(let err):
            print("Erreur : \(err)")
            return []
        }
    }
    func createIngredient( _ ingredient:Ingredient) async -> Result<Int,APIError>{
        let ingredientDTO = IngredientDTOPOST(ID: ingredient.id, NAME: ingredient.name, UNIT: ingredient.unit.description, UNIT_PRICE: ingredient.unitPrice, ID_Category: ingredient.category, STOCK: ingredient.stock, ALLERGEN: ingredient.allergen?.id)
        
        return await URLSession.shared.create(from: URL(string: self.API+"createIngredient")!, element: ingredientDTO)
        
        
    }
    func update( _ ingredient:Ingredient) async -> Result<Bool,APIError>{
        let ingredientDTO = IngredientDTOPOST(ID: ingredient.id, NAME: ingredient.name, UNIT: ingredient.unit.description, UNIT_PRICE: ingredient.unitPrice, ID_Category: ingredient.category, STOCK: ingredient.stock, ALLERGEN: ingredient.allergen?.id)
        
        return  await URLSession.shared.update(from: URL(string: self.API + "updateIngredient")!, element: ingredientDTO )
        
        
    }
    func delete(_ id :Int) async -> Result<Bool,APIError>{
        
        return await URLSession.shared.delete(from: URL(string: self.API + "deleteIngredient")!, id: id)
    }
    
}
