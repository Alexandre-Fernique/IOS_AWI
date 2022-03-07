

import SwiftUI

struct RecipeUpdateUI: View {
    @Environment(\.presentationMode) var presentationMode
    var intent : IntentRecipe
    @ObservedObject var recipeVM:RecipeVM
    @State private var stepList :[Step] = []
    @State var categoryList :[Category] = []
    @State private var textAlert = ""
    @State private var showingAlertNotDismiss = false
    @State private var showingAlert = false
    init(recipe:Recipe){
        self.recipeVM = RecipeVM(model: recipe)
        self.intent = IntentRecipe()
        self.intent.addObserver(viewModel: recipeVM)
        
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
                                Text("Aucu n").tag(0)
                                ForEach(stepList,id:\.id){
                                        stepPicker in
                                    Text(stepPicker.name)
                                }
                            
                        }
                    }.swipeActions(content: {
                        Button(role: .destructive) {
                            recipeVM.stepList.removeAll(where: {
                                return element.id == $0.id
                            })
                            
                            
                        } label: {
                                Label("Delete", systemImage: "trash")
                        }
                    })
                    
                }
                Button("+"){
                    recipeVM.stepList.append(Step(id: 0, name: "", description: "", duration: 0, ingredient: []))
                    
                    
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                
                Section{
                    Button("Enregistrer"){
                        Task{
                            intent.intentTestValidation(recipe: recipeVM.getRecipe())
                            
                            if recipeVM.error == .noError{
                                let data = await APIservice.recipeDAO().update(recipeVM.model)
                                switch data{
                                    case .success(_):
                                    showingAlertNotDismiss = true
                                    textAlert = "Mis à jour"
                                    
                                
                                case .failure(let err):
                                    showingAlert = true
                                    textAlert = "Erreur \(err)"
                                    
                                }
                            }
                            
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).alert(self.textAlert,isPresented:$showingAlertNotDismiss ){
                        Button("OK",role:.cancel){
                            
                                                    }
                    }
                    
                    Button("Supprimer"){
                        Task{
                            let data = await APIservice.recipeDAO().delete(recipeVM.model.id)
                            switch data{
                            case .success(_):
                                    showingAlert = true
                                    textAlert = "Recette supprimer"
                                    self.presentationMode.wrappedValue.dismiss()
                                
                            case .failure(let err):
                                showingAlert = true
                                textAlert = "Erreur \(err)"
                                
                            }
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).foregroundColor(.red).alert(self.textAlert,isPresented: $showingAlert){
                        Button("OK",role:.cancel){

                            
                        }
                    }
                
                }
            }.onAppear{
                loadData()
            }
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

struct RecipeUpdateUI_Previews: PreviewProvider {
    static var previews: some View {
        RecipeUpdateUI(recipe: Recipe(id: 0, name: "", author: "", idCategory: 0, nbCouvert: 0, coutAssaisonement: 0, isPercent: 0, stepList: []))
    }
}
