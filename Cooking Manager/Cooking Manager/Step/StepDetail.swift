//
//  StepDetail.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI
import AlertToast

struct StepDetailUI: View {
    @Environment(\.presentationMode) var presentationMode
    var intent:IntentStep
    @ObservedObject var stepVM:StepVM
    @State var showingAlertNotDismiss = false
    @State var showingAlert = false
    @State var textAlert = ""
    @State var errorAlert = false
    @State var ingredientList :[Ingredient] = []
    @State private var searchText = ""
    private var searchResults: [Ingredient] {
            if searchText.isEmpty {
                return ingredientList
            } else {
                return ingredientList.filter { $0.name.uppercased().contains(searchText.uppercased()) }
            }
        }
    init(step:Step,steps:StepsVM){
        self.stepVM = StepVM(model: step)
        self.intent = IntentStep()
        intent.addObserver(viewModel: stepVM)
        intent.addListObserver(viewModel: steps)
    }
    var body: some View {
        VStack{
            Form {
                FloatingTextField("Nom", text: $stepVM.name).onSubmit {
                    
                }
                FloatingTextField("Description", text: $stepVM.description).onSubmit {
                    
                }
                
                FloatingValueField("Durée(en minute)", value: $stepVM.duration,format:.number).onSubmit {
                    
                }.keyboardType(.numberPad)
                List($stepVM.ingredient){ $element in
                    HStack{
                        FloatingValueField("Quantité :", value: $element.quantity ,format: .number)
                        Picker("",selection: $element.ingredient.id) {
                            Text("Ingrédient").tag(0)
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
                    Button("Enregistrer"){
                        Task{
                            intent.intentTestValidation(step: stepVM.getStep())
                            if stepVM.error == .noError{
                                
                                let data = await intent.intentValidation(step: stepVM.copyModel)
                                switch data{
                                case .success(_):
                                    showingAlert = true
                                    textAlert = "Étape mis à jour"
                                case .failure(let err):
                                    errorAlert = true
                                    textAlert = "Erreur \(err)"
                                }
                            }
                        }
                        
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    
                    Button("Supprimer"){
                        Task{
                            let data = await intent.intentDeleteRequest(id: stepVM.id)
                            
                            switch data{
                            case .success(_):
                                self.presentationMode.wrappedValue.dismiss()
                                
                            case .failure(let err):
                                errorAlert = true
                                textAlert = "Erreur \(err)"
                            }

                        }
                                                
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).foregroundColor(.red)
                
                }
                
            }.onChange(of: stepVM.error) { error in
                print(error)
                if error != .noError{
                    textAlert = "\(error)"
                    errorAlert = true
                }
                    
            }
        }.toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }).toast(isPresenting: $showingAlertNotDismiss, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        }).toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        },completion: {
            stepVM.error = .noError
            errorAlert = false
        }).onAppear(){
            loadData()
        }
        
    }
    func loadData(){
        Task{
            self.ingredientList = await APIservice.ingredientDAO().getIngredient()
        }
    }
}

struct StepDetail_Previews: PreviewProvider {
    static var previews: some View {
        StepDetailUI(step: Step(id: 0, name: "", description: "", duration: 0, ingredient: []),steps: StepsVM(steps: []))
    }
}
