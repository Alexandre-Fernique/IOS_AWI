//
//  APIService.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class APIservice{
    static var API = ""
    
    static func categoryDAO()->CategoryDAO{
        return CategoryDAO(fromApi: self.API)
    }
    static func ingredientDAO()->IngredientDAO{
        return IngredientDAO(fromApi: self.API)
    }
    static func allergenDAO()->AllergenDAO{
        return AllergenDAO(fromApi: self.API)
    }
    static func stepDAO()->StepDAO{
        return StepDAO(fromApi: self.API)
    }
    static func recipeDAO()->RecipeDAO{
        return RecipeDAO(fromApi: self.API)
    }
    
}
