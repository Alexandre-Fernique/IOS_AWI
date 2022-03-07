//
//  AllergenDetail.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI
import AlertToast

struct AllergenDetailUI: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var allergenVM :AllergenVM
    var intent :IntentAllergen
    @State var categoryList:[Category] = []
    @State private var showingAlert = false
    @State private var errorAlert = false
    @State private var textAlert = ""
    
    init(allergen:Allergen,listVM:AllergensVM){
        self.allergenVM = AllergenVM(model: allergen)
        self.intent = IntentAllergen()
        self.intent.addObserver(viewModel: self.allergenVM)
        self.intent.addListObserver(viewModel: listVM)

    }
    var body: some View {
        Form{
            FloatingTextField("Nom", text: $allergenVM.name)
            Picker(selection: $allergenVM.idCategory, label: Text("Catégorie")) {
                ForEach(categoryList,id:\.id){
                    category in
                    Text(category.name).tag(category)
                }
            }
            
            
            Section{
                Button("Enregistrer"){
                    Task{
                        intent.intentTestValidation(allergen: allergenVM.getAllergen())
                        if allergenVM.error == .noError {
                            let data = await intent.intentValidation(allergen: allergenVM.copyModel)
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
                        let data = await intent.intentDeleteRequest(id: allergenVM.id)
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
        }.toast(isPresenting: $showingAlert, alert: {
            AlertToast(displayMode: .hud, type: .complete(.green), title: textAlert)
        },completion: {
            showingAlert = false
        }).toast(isPresenting: $errorAlert, alert: {
            AlertToast(displayMode: .hud, type: .error(.red), title: textAlert)
        },completion: {
            allergenVM.error = .noError
            errorAlert = false
        }).onAppear(){
            loadData()
        }
        
    }
    func loadData(){
        Task{
            self.categoryList = await APIservice.categoryDAO().getCategory(type: .allergen)
            
        }
        
    }
}

struct AllergenDetail_Previews: PreviewProvider {
    static var previews: some View {
        AllergenDetailUI(allergen: Allergen(id: 0, name: "", idCategory: 0, url: URL(string: "")!), listVM: AllergensVM(allergens: []))
    }
}
