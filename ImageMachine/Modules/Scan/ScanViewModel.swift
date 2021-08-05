//
//  ScanViewModel.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 01/08/21.
//

import Foundation

protocol ScanRoutes : AppFlow{
    func goBack()
    func goToMachineDetail(machine : ImageMachine)
}

class ScanViewModel {
    
    private let coordinator : ScanRoutes!
    
    init(coordinator : ScanRoutes) {
        self.coordinator = coordinator
    }
    
    func goBack(){
        coordinator.goBack()
    }
    
    func goToDetail(id : String){
        print("Code : \(id)")
        // TODO: Need convert to image machine
//        coordinator.goToMachineDetail(machineId: id)
    }
    
}
