
import Foundation

struct RecipePostDTO:Encodable{
    var ID: Int
    var NAME : String
    var AUTHOR :String
    var ID_Category : Int
    var NB_COUVERT : Int
    var COUT_ASSAISONNEMENT : Double
    var ISPERCENT : Int
    var STEP:[StepPostDTOForRecipe]
    init(ID: Int,NAME : String,AUTHOR :String,ID_Category : Int,NB_COUVERT : Int,COUT_ASSAISONNEMENT : Double,ISPERCENT : Int, STEP:[StepPostDTOForRecipe]){
        self.ID = ID
        self.NAME = NAME
        self.AUTHOR = AUTHOR
        self.ID_Category = ID_Category
        self.NB_COUVERT = NB_COUVERT
        self.COUT_ASSAISONNEMENT = COUT_ASSAISONNEMENT
        self.ISPERCENT = ISPERCENT
        self.STEP = STEP
    }
}
