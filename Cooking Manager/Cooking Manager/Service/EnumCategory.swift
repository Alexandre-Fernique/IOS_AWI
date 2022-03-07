//
//  Category.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation



enum TypeCategory:CustomStringConvertible{
    case recipe
    case ingredient
    case allergen

    var description : String {
        switch self {
            case .recipe: return "R_Category"
            case .ingredient: return "I_Category"
            case .allergen: return "A_Category"
        }
        
    }
    
}
