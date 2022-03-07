//
//  CategoriesDAO.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation

struct CategoryDAO{
    var API:String
    
    init(fromApi:String){
        self.API = fromApi
    }
    func getCategory(type:TypeCategory) async ->[Category] {
        let data:Result<[CategoryDTO],APIError>  = await URLSession.shared.getJSON(from: URL(string: self.API + "/category/getCategory/\(type)")!)
        switch data{
        case .success(let DTO):
            var category:[Category] = []
            DTO.forEach{ element in
                category.append(element.DTOtoValue())
            }
            return category
        case .failure(let err):
            print("Erreur : \(err)")
            return []
        }
    }
}
