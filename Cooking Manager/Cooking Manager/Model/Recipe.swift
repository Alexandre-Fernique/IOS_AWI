

import Foundation

class Recipe{
    var id: Int
    var name : String
    var author :String
    var idCategory : Int
    var nbCouvert : Int{
        didSet{
            if self.nbCouvert <= 0{
                self.nbCouvert = oldValue
            }
        }
    }
    var coutAssaisonement : Double
    var isPercent : Int
    var stepList:[Step]
    var stepIdList:[Int] = []
    
    init(id: Int,name : String,author :String,idCategory : Int,nbCouvert : Int,coutAssaisonement : Double,isPercent : Int,stepList:[Step]){
        self.id = id
        self.name = name
        self.author = author
        self.idCategory = idCategory
        self.nbCouvert = nbCouvert
        self.coutAssaisonement = coutAssaisonement
        self.isPercent = isPercent
        self.stepList = stepList
        stepList.forEach({element in
            self.stepIdList.append( element.id)
            
        })
    }
    init(recipe: Recipe,stepList:[Step]){
        self.id = recipe.id
        self.name = recipe.name
        self.author = recipe.author
        self.idCategory = recipe.idCategory
        self.nbCouvert = recipe.nbCouvert
        self.coutAssaisonement = recipe.coutAssaisonement
        self.isPercent = recipe.isPercent
        self.stepList = stepList
        stepList.forEach({element in
            self.stepIdList.append(element.id)
            
        })
    }
    func coutIngre()->Double{
        var sum :Double = 0
        stepList.forEach({elment in
            sum += elment.getCout() * Double(nbCouvert)
        })
        return sum
    }
    func coutAssainoment()->Double{
        
        let coutIngre = coutIngre()
        if isPercent == 1 {
            return coutIngre * (coutAssaisonement/100)
        }else{
            return coutIngre + coutAssaisonement
            
        }
    }
    func coutMatiere()->Double{
        return coutIngre() + coutAssaisonement
    }
}
