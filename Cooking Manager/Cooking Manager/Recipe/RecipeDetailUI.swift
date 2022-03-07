
import SwiftUI

struct RecipeDetailUI: View {
    @Environment(\.presentationMode) var presentationMode
    var etiquette:Etiquette
    @State var recipe : Recipe?
    @State var text = ""
    init(etiquette:Etiquette){
        self.etiquette = etiquette
        self.recipe = nil
    }
    @State var modifyRecipe = false
    
    var body: some View {
        Group{
                VStack{
                if let recipe = recipe {
                    NavigationLink(destination:RecipeUpdateUI(recipe: recipe),isActive: $modifyRecipe){}
                    VStack{
                        List{
                            ForEach(recipe.stepList,id:\.id){
                                step in
                                Section(step.name)
                                {
                                    Text("Durée : \(step.getDuration())")
                                    Text("Description : \(step.description)")
                                    ForEach(step.ingredient,id:\.ingredient.id){
                                        element in
                                        Text("\(element.ingredient.name)  \(element.quantity) \(element.ingredient.unit.description)")
                                       
                                        
                                    }
                                }.font(.headline)
                            }
                            Section("Coût"){
                                Text("Coût ingrédient: \(recipe.coutIngre())")
                                Text("Coût assaisonement: \(recipe.coutAssainoment())")
                                Text("Coût matière \(recipe.coutMatiere())")
                                
                            }
                            
                        }.navigationTitle(recipe.name).toolbar{
                            Button {
                                modifyRecipe = true
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                    }
                                
                
            }
                
                
            }.onAppear{
                self.loadData()
            }
        }
        
    }

    
    func loadData(){
        Task{
            self.recipe = await APIservice.recipeDAO().get(id: self.etiquette.id)
            
        }
    }
}

struct RecipeDetailUI_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailUI(etiquette: Etiquette(id: 0, name: "", author: "", idCategory: 0, ingredientList: []))
    }
}
