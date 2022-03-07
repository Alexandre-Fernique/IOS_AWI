

import SwiftUI

struct RecipeCreateUI: View {
    @Environment(\.presentationMode) var presentationMode
    var intent :IntentRecipe
    @ObservedObject var recipeVM:RecipeVM
    @State private var stepList :[Step] = []
    @State var categoryList:[Category] = []
    @State var showingAlert = false
    @State var textAlert = ""
    init(){
        self.recipeVM = RecipeVM(model: Recipe(id: 0, name: "", author: "", idCategory: 0, nbCouvert: 0, coutAssaisonement: 0, isPercent: 0, stepList: []))
        intent = IntentRecipe()
        intent.addObserver(viewModel: recipeVM)
    }
    var body: some View {
        VStack{
            Form{
                FloatingTextField("Nom", text: $recipeVM.name)
                FloatingTextField("Auteur", text: $recipeVM.author)
                Stepper(value: $recipeVM.nbCouvert, in: 1...50,step: 1) {
                    FloatingValueField("Nombre de couvert", value: $recipeVM.nbCouvert, format: .number).keyboardType(.numberPad)
                    
                }
                Picker(selection: $recipeVM.idCategory, label: Text("Catégorie")) {
                    ForEach(categoryList,id:\.id){
                        category in
                        Text(category.name).tag(category)
                    }
                }
                List($recipeVM.stepList){ $element in
                    HStack{
                        Picker("Étape",selection: $element.id) {
                                Text("Aucun").tag(0)
                                ForEach(stepList,id:\.id){
                                        stepPicker in
                                    Text(stepPicker.name)
                                }
                            
                        }
                    }.swipeActions(content: {
                        Button(role: .destructive) {
                            
                        } label: {
                                Label("Delete", systemImage: "trash")
                        }
                    })
                    
                }
                Button("+"){
                    recipeVM.stepList.append(Step(id: 0, name: "", description: "", duration: 0, ingredient: []))
                    
                    
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                Section{
                    Button("Créer"){
                        Task{
                            intent.intentTestValidation(recipe: recipeVM.getRecipe())
                            
                            if recipeVM.error == .noError{
                                print("FetechApi")
                                let data = await APIservice.recipeDAO().create(recipeVM.model)
                                switch data{
                                    case .success(_):
                                    showingAlert = true
                                    textAlert = "Recette créée"
                                    self.presentationMode.wrappedValue.dismiss()
                                    
                                
                                case .failure(let err):
                                    showingAlert = true
                                    textAlert = "Erreur \(err)"
                                    
                                }
                            }
                            
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
                
            }
            
        }.onAppear{
            loadData()
        }
    
    }
    func loadData(){
        Task{
            self.stepList = await APIservice.stepDAO().get()
            
        }
        Task{
            self.categoryList = await APIservice.categoryDAO().getCategory(type: .recipe)
        }
       
        
    }
}

struct RecipeCreateUI_Previews: PreviewProvider {
    static var previews: some View {
        RecipeUpdateUI(recipe: Recipe(id: 0, name: "", author: "", idCategory: 0, nbCouvert: 0, coutAssaisonement: 0, isPercent: 0, stepList: []))
    }
}

