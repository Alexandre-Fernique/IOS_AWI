
//
import SwiftUI
import AlertToast
struct IngredientCreateUI: View {
    
    @ObservedObject var ingredientVM : IngredientVM
    @Environment(\.presentationMode) var presentationMode

    var intent : IntentIngredient
    @State var categoryList:[Category] = []
    @State var allergenList:[Allergen] = []
    @State private var selectedAllergen :Int = 0
    @State private var textAlert = ""
    @State private var errorAlert = false
    @State private var selectedUnit:Unit = .Kg
    
    
    init(ingredientsVM:IngredientsVM){
        self.ingredientVM = IngredientVM(model: Ingredient(id: 0, name: "", unit: .Kg, unitPrice: 0, category: 0, stock: 0, allergen: nil))
        self._categoryList = State(initialValue: ingredientsVM.categoryIngredient)
        self.intent = IntentIngredient()
        self.intent.addObserver(viewModel: ingredientVM)
        self.intent.addListObserver(viewModel: ingredientsVM)
                
    }
    var body: some View {
        VStack{
            Form {
                FloatingTextField("Nom", text: $ingredientVM.name)
                Picker(selection: $ingredientVM.category, label: Text("Catégorie")) {
                    ForEach(categoryList,id:\.id){
                        category in
                        Text(category.name).tag(category)
                    }
                }
                FloatingValueField("Prix unitaire", value: $ingredientVM.unitPrice,format:.number).keyboardType(.decimalPad)
                    
                Picker(selection: $selectedUnit, label: Text("Unité")) {
                        ForEach(Unit.allCases){unit in
                            Text(unit.description)
                        }
                    }.onChange(of: self.selectedUnit, perform: {
                        _ in
                        
                        //intent.intentToChange(unit:  self.selectedUnit)
                    })
                
                
                
                FloatingValueField("Stock", value: $ingredientVM.stock ,format:.number).keyboardType(.decimalPad)
                Picker(selection: $selectedAllergen, label: Text("Allergène")) {
                    Text("Aucun").tag(0)
                    ForEach(allergenList,id:\.id){
                        allergen in
                        Text(allergen.name).tag(allergen)
                    }
                }.onChange(of: self.selectedAllergen, perform: {
                    _ in
                    print("Value \(selectedAllergen)")
                    if  selectedAllergen == 0{
                        ingredientVM.allergen = nil
                        
                    }else{
                        let newValue = allergenList.first(where: {
                            test in
                            return test.id == selectedAllergen
                            
                        })
                        ingredientVM.allergen = newValue
                        
                    }
                    
                })
                
                Section{
                    Button("Créer"){
                        Task{
                            intent.intentTestValidation(ingredient: ingredientVM.getIngredientFromVM())
                            
                            if ingredientVM.error == .noError{
                                let data = await APIservice.ingredientDAO().createIngredient(ingredientVM.copyModel)
                                switch data{
                                    case .success(let id):
                                    ingredientVM.copyModel.id = id
                                    intent.intentCreateRequest(element: ingredientVM.copyModel)
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure(let err):
                                    errorAlert = true
                                    textAlert = "Erreur \(err)"
                                    
                                }
                            }
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

                }
 
            }.onChange(of: ingredientVM.error) { error in
                print(error)
                if error != .noError{
                    textAlert = "\(error)"
                    errorAlert = true
                }
                    
            }
        }.toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        },completion: {
            ingredientVM.error = .noError
            errorAlert = false
        }).onAppear(){
            loadData()
        }
    }
    func loadData(){
        Task{
            self.allergenList = await APIservice.allergenDAO().getAllergen()
        }
    }
    
        
}


struct IngredientCreate_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCreateUI(ingredientsVM: IngredientsVM(ingredients:[]))
    }
}


