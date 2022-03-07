//
//  AllergenList.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI
import AlertToast
struct AllergenListUI: View {
    @State var categoryList :[Category] = []
    @ObservedObject var allergensVM = AllergensVM(allergens: [])
    @State private var dataIsLoad = false
    @State var createAllergen = false
    
    var body: some View {
        VStack{
            
            NavigationView {
                VStack{
                    NavigationLink(destination:AllergenCreateUI(listVM: allergensVM),isActive: $createAllergen){}
                    List{
                    ForEach(categoryList,id:\.id){
                        category in
                        Section(category.name)
                        {
                            ForEach(allergensVM.allergens,id:\.id){
                                element in
                                if( element.idCategory == category.id){
                                    NavigationLink(destination:AllergenDetailUI(allergen: element, listVM: allergensVM)){
                                        HStack{
                                            Text(element.name)
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                    }

                }
                    
                    
                }
                .onAppear(){
                    loadData()
                    
                }.navigationTitle("Allergène")
                    .toolbar{
                        
                        Button("+") {
                            createAllergen = true
                            
                    
                        }
                        
                        
                        
                        
                    }
                
                
            }.overlay(Group{
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            }).toast(isPresenting: $allergensVM.alert, alert: {
                AlertToast(displayMode: .hud, type: .complete(.green), title: allergensVM.textAlert)
            },completion: {allergensVM.alert = false})
            
            
            
        }
    
    }
    func loadData(){
        Task{
            self.categoryList = await APIservice.categoryDAO().getCategory(type: .allergen)
            dataIsLoad = true
        }
        Task{
            self.allergensVM.allergens = await APIservice.allergenDAO().getAllergen()
        }
        
    }
        
}

struct AllergenList_Previews: PreviewProvider {
    static var previews: some View {
        AllergenListUI()
    }
}
