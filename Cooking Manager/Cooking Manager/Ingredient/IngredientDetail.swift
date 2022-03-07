//
//  IngredientDetail.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//
import SwiftUI
import AlertToast

struct IngredientDetailUI: View {

    @ObservedObject var ingredientVM : IngredientVM

    var intent : IntentIngredient
    @State var categoryList:[Category] = []
    @State var allergenList:[Allergen] = []
    @State private var selectedAllergen :Int
    @State private var showingAlert = false
    @State private var showingAlertNotDismiss = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    @State private var selectedUnit:Unit = .Kg
    
    
    init(ingredient:Ingredient,ingredientsVM:IngredientsVM){
        self.ingredientVM = IngredientVM(model: ingredient)
        self.intent = IntentIngredient()
        self.categoryList = ingredientsVM.categoryIngredient
        if let allergen = ingredient.allergen{
            self.selectedAllergen = allergen.id
        } else{
            self.selectedAllergen = 0
        }
        self.selectedUnit = ingredient.unit
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
                }
                
                
                
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
                    Button("Enregistrer"){
                        Task{
                            intent.intentTestValidation(ingredient: ingredientVM.getIngredientFromVM())
                            
                            if ingredientVM.error == .noError{
                                let data = await intent.intentValidation(ingredient: ingredientVM.copyModel)
                                switch data{
                                    case .success(_):
                                
                                    showingAlert = true
                                    textAlert = "Mis à jour"
                                    
                                
                                case .failure(let err):
                                    errorAlert = true
                                    textAlert = "Erreur \(err)"
                                    
                                }
                            }
                            
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    
                    Button("Supprimer"){
                        Task{
                            let data = await intent.intentDeleteRequest(id: ingredientVM.id)
                            switch data{
                            case .success(_):
                                    break
                                
                            case .failure(let err):
                                errorAlert = true
                                textAlert = "Erreur \(err)"
                                
                            }
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).foregroundColor(.red)
                        
                
                }.onChange(of: ingredientVM.error) { error in
                    print(error)
                    if error != .noError{
                        textAlert = "\(error)"
                        errorAlert = true
                    }
                        
                }
                
            }
            
        }.toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        },completion: {
            showingAlert = false
        }).toast(isPresenting: $errorAlert, alert: {
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

struct IngredientDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        IngredientDetailUI(ingredient: Ingredient(id: 0, name: "", unit: .Kg, unitPrice: 0, category: 0, stock: 0, allergen: nil), ingredientsVM: IngredientsVM(ingredients:[]))
    }
}

