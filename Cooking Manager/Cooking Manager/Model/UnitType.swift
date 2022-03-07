//
//  UnitType.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import Foundation


enum Unit:CustomStringConvertible,CaseIterable,Identifiable{
    var id:Self {self}
    case Kg
    case L
    case Botte
    case P
    case U
    case unknow

    var description : String {
        switch self {
            case .Kg: return "Kg"
            case .L: return "L"
            case .Botte: return "Botte"
            case .P :return "Pièce"
            case .U :return "Unité"
            case .unknow :return "unknow"
        }
        
    }
    
}

