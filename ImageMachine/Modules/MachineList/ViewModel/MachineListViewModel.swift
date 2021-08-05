//
//  MachineListViewModel.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation
import Combine
import UIKit

protocol MachineListRoutes : AppFlow {
    func goToCamera()
    func goToMachineDetail(machine : ImageMachine)
    func goToAddMachineList()
}

class MachineListViewModel {
    
    let coordinator : MachineListRoutes!
    let machineService : MachineImageService!
    
    var data : CurrentValueSubject<[MachineListViewData], Error> = CurrentValueSubject([])
    
    init(coordinator : MachineListRoutes, machineService : MachineImageService) {
        self.coordinator = coordinator
        self.machineService = machineService
        
        getAllMachine()
    }
    
    func getAllMachine(){
        
        let views = machineService.getAllMachine()
        data.send(views)
    }
    
    func goToMachineDetail(id : String){
        if let imageMachine = machineService.getMachine(with: id) {
            coordinator?.goToMachineDetail(machine: imageMachine)
        } else {
            print("Image Machine is NULL")
        }
    }
    
    func goToCamera() {
        coordinator?.goToCamera()
    }
    
    func goToAddMachineList(){
        coordinator?.goToAddMachineList()
    }
    
    func sortType(){
        let tempData = data.value.sorted{ $0.type.lowercased() < $1.type.lowercased() }
        data.send(tempData)
    }
    
    func sortName(){
        let tempData = data.value.sorted{ $0.name.lowercased() < $1.name.lowercased() }
        data.send(tempData)
    }
    
}
