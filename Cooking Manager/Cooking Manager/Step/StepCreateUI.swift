//
//  StepDetail.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI

struct StepCreateUI: View {
    @Environment(\.presentationMode) var presentationMode
    var intent :IntentStep
    @ObservedObject var stepVM:StepVM
    @State var showingAlertNotDismiss = false
    @State var showingAlert = false
    @State var errorAlert = false 
    @State var textAlert = ""
    @State var ingredientList :[Ingredient] = []
    @State private var searchText = ""
    private var searchResults: [Ingredient] {
            if searchText.isEmpty {
                return ingredientList
            } else {
                return ingredientList.filter { $0.name.uppercased().contains(searchText.uppercased()) }
            }
        }
    init(stepsVM:StepsVM){
        self.stepVM = StepVM(model: Step(id: 0, name: "", description: "", duration: 0, ingredient: []))
        intent = IntentStep()
        intent.addObserver(viewModel: stepVM)
        intent.addListObserver(viewModel: stepsVM)
    }
    var body: some View {
        VStack{
            Form {
                FloatingTextField("Nom", text: $stepVM.name).onSubmit {
                    
                }
                FloatingTextField("Description", text: $stepVM.description).onSubmit {
                    
                }
                
                FloatingValueField("Durée", value: $stepVM.duration,format:.number).onSubmit {
                    
                }.keyboardType(.numberPad)
                List($stepVM.ingredient){ $element in
                    HStack{
                        FloatingValueField("Quantité :", value: $element.quantity ,format: .number)
                        Picker(selection: $element.ingredient.id, label: Text("")) {
                            
                            Text("Ingrédient").tag(0).searchable(text: $searchText)
                            ForEach(searchResults,id:\.id){
                                ingrePicker in
                                Text(ingrePicker.name)
                            }
                        }
                        
                    }.swipeActions(content: {
                        Button(role: .destructive) {
                            stepVM.ingredient.removeAll(where: {
                                return element.ingredient.id == $0.ingredient.id
                            })
                            
                        } label: {
                                Label("Delete", systemImage: "trash")
                        }
                    })
                    
                }
                Button("+"){
                    stepVM.ingredient.append(IngredientQuantity())
                    
                    
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                
                Section{
                    Button("Créer"){
                        Task{
                            intent.intentTestValidation(step: stepVM.getStep())
                            if stepVM.error == .noError {
                                let data = await intent.intentCreateRequest(element: stepVM.copyModel)
                                switch data{
                                case .success(_):
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure(let err):
                                    textAlert = "\(err)"
                                    errorAlert = true
                                }
                            }
                            
                            
                        }
                        
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }

                
                
            }.onChange(of: stepVM.error) { error in
                print(error)
                if error != .noError{
                    textAlert = "\(error)"
                    errorAlert = true
                }
                    
            }.alert(textAlert,isPresented: $errorAlert) {
                Button("Ok", role: .cancel){
                    errorAlert = false
                    stepVM.error = .noError
                }
            }.task {
                self.ingredientList = await APIservice.ingredientDAO().getIngredient()
            }
            
            
            
            
        }
        
    }
}

struct StepCreateUI_Previews: PreviewProvider {
    static var previews: some View {
        StepCreateUI(stepsVM: StepsVM(steps: []))
    }
}
