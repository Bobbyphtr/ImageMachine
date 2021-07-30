//
//  MachineListViewModel.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation

protocol MachineListRoutes {
    func goToCamera()
    func goToMachineDetail(machine : String)
}

class MachineListViewModel {
    
    var coordinator : MachineListRoutes?
    
    let data = ["Machine 1", "Machine 2", "Machine 3"]
    
    init(coordinator : MachineListRoutes) {
        self.coordinator = coordinator
    }
    
    func goToMachineDetail(machine : String){
        coordinator?.goToMachineDetail(machine: machine)
    }
    
    func goToCamera() {
        coordinator?.goToCamera()
    }
    
}
