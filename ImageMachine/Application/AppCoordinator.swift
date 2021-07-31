//
//  AppCoordinator.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation
import UIKit
import SwiftUI

class AppCoordinator : Coordinator {
    
    var navigationController: UINavigationController!
    
    let storyboard = UIStoryboard.instantiate(named: "Main")
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Machine List
        let vc = MachineListController.instantiate(from: storyboard)
        vc.viewModel = MachineListViewModel(coordinator:  self)
        navigationController.pushViewController(vc, animated: false)
    }
    
}

extension AppCoordinator : MachineListRoutes {
    
    func goToCamera() {
        print("Go to Scan QR")
    }
    
    func goToMachineDetail(machine : String) {
        print("Go to Machine Detail \(machine)")
        let model = MachineDetailsObservable.init()
        model.machineData = machine
        let view = MachineDetailSwiftUI().environmentObject(model)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
