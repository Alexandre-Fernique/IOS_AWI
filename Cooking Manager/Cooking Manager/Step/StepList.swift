//
//  StepList.swift
//  Cooking Manager
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI
import AlertToast
struct StepListUI: View {
    @State private var dataIsLoad = false
    @ObservedObject var stepsVM = StepsVM(steps: [])
    @State var createStep = false
    
    
    var body: some View {
        VStack{
            NavigationView {
                VStack{
                    NavigationLink(destination:StepCreateUI(stepsVM: self.stepsVM),isActive: $createStep){}
                    List{
                        ForEach(stepsVM.steps,id:\.id){
                            step in
                            NavigationLink(destination:StepDetailUI(step: step,steps: stepsVM)){
                                VStack(alignment: .leading){
                                    Text(step.name)
                                    Text("Durée : \(step.getDuration())").opacity(0.5).font(.system(size: 15))
                                    Text("\(step.description)").opacity(0.5).font(.system(size: 15))
                                }
                            }
                        }
                    }
                    .onAppear(){
                        loadData()
                        
                    }.toolbar{
                        Button("+") {
                            createStep = true
                            
                        }
                    }.navigationTitle("Étapes")
                        
                }
            }.overlay(Group{
                ProgressView().opacity(dataIsLoad ? 0 : 1)
            }).toast(isPresenting: $stepsVM.alert, alert: {
                
                AlertToast(displayMode: .hud, type: .complete(.green), title: stepsVM.textAlert)
            },completion: {stepsVM.alert = false})
            
        }
    }
    func loadData(){
        Task{
            self.stepsVM.steps = await APIservice.stepDAO().get()
            dataIsLoad = true
        }
        
    }
}

struct StepList_Previews: PreviewProvider {
    static var previews: some View {
        StepListUI()
    }
}
