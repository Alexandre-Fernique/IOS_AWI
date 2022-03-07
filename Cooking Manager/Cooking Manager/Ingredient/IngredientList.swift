
import SwiftUI
import AlertToast

struct IngredientListUI: View {
    @ObservedObject var ingredientsVM : IngredientsVM = IngredientsVM(ingredients: [])
    @State private var searchText = ""
    @State private var createIngredient = false
    @State private var dataIsLoad = false
    private var searchResults: [Ingredient] {
            if searchText.isEmpty {
                return ingredientsVM.ingredients
            } else {
                return ingredientsVM.ingredients.filter { $0.name.uppercased().contains(searchText.uppercased()) }
            }
        }
    
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination:IngredientCreateUI(ingredientsVM: ingredientsVM),isActive: $createIngredient){}
                    List{
                        
                        ForEach(ingredientsVM.categoryIngredient,id:\.id){
                            category in
                            Section(category.name)
                            {
                                ForEach(searchResults,id:\.id){
                                    element in
                                    if( element.category == category.id){
                                        NavigationLink(destination:IngredientDetailUI(ingredient: element, ingredientsVM: ingredientsVM)){
                                            HStack{
                                                Text(element.name)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }.searchable(text: $searchText)
                    .onAppear(){
                        loadData()
                        
                    }.toolbar{
                        Button("+") {
                                createIngredient = true
                        }
                    }.navigationTitle("Ingrédients")
                }
            }.overlay(Group{
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            }).toast(isPresenting: $ingredientsVM.alert, alert: {
                
                AlertToast(displayMode: .hud, type: .complete(.green), title: ingredientsVM.textAlert)
            },completion: {ingredientsVM.alert = false})
            
        }
    }
    
    func loadData(){
        Task{
            self.ingredientsVM.categoryIngredient =  await APIservice.categoryDAO().getCategory(type: .ingredient)
            dataIsLoad = true
        }
        Task{
            self.ingredientsVM.ingredients =  await APIservice.ingredientDAO().getIngredient()
        }
        
    }
}

struct IngredientList_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListUI()
    }
}
