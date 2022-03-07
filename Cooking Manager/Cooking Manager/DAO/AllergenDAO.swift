//
//  AllergenDAO.swift
//  Cooking Manager
//
//  Created by m1 on 27/02/2022.
//

import Foundation
struct AllergenDAO{
    var API:String
    
    init(fromApi:String){
        self.API = fromApi + "/allergen/"
    }
    func getAllergen() async ->[Allergen] {
        let data:Result<[AllergenDTO],APIError>  = await URLSession.shared.getJSON(from: URL(string: self.API + "getAll")!)
        switch data{
        case .success(let DTO):
            var allergenList:[Allergen] = []
            DTO.forEach{ allergen in
                if let notNilAllergen = allergen.DTOtoValue(){
                    allergenList.append(notNilAllergen)
                }
            }
            return allergenList
        case .failure(let err):
            print("Erreur : \(err)")
            return []
        }
    }
    func create( _ allergen:Allergen) async -> Result<Int,APIError>{
        let allergenDTO = AllergenDTO(ID: nil, NAME: allergen.name, ID_Category: allergen.idCategory, URL: nil)
        
        return await URLSession.shared.create(from: URL(string: self.API+"createAllergen")!, element: allergenDTO)
        
        
    }
    func update( _ allergen:Allergen) async -> Result<Bool,APIError>{
        let allergenDTO =  AllergenDTO(ID: allergen.id, NAME: allergen.name, ID_Category: allergen.idCategory, URL: nil)
        
        return  await URLSession.shared.update(from: URL(string: self.API + "updateAllergen")!, element: allergenDTO )
        
        
    }
    func delete(_ id :Int) async -> Result<Bool,APIError>{
        
        return await URLSession.shared.delete(from: URL(string: self.API + "deleteAllergen")!, id: id)
    }
    
}
