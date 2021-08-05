//
//  EditMachineViewModel.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 03/08/21.
//

import Foundation

protocol EditMachineRoutes : AppFlow {
    func goBack()
}

class EditMachineViewModel : ObservableObject {
    
    // coordinator
    private var coordinator : EditMachineRoutes!
    private var service : MachineImageService!
    
    // input
    @Published private var data : ImageMachine!
    
    // output
    @Published var currentName : String!
    @Published var currentType : String!
    @Published var currentTime : Date!
    
    init(currentData : ImageMachine, coordinator : EditMachineRoutes, service : MachineImageService) {
        self.data = currentData
        self.coordinator = coordinator
        self.service = service
        
        self.currentName = data.name
        self.currentType = data.type
        self.currentTime = data.lastMaintenance
        
    }
    
    func saveInformationData(){
        service.updateMachine(name: currentName, type: currentType, maintenanceTime: currentTime, currentMachineImage: data)
        coordinator.goBack()
    }
}
