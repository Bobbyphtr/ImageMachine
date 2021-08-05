//
//  AppCoordinator.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

protocol AppFlow {
    func showWarningDialog(message : String)
}

class AppCoordinator : Coordinator {
    
    var navigationController: UINavigationController!
    
    private let storyboard = UIStoryboard.instantiate(named: "Main")
    
    private let machineService = MachineImageServiceImpl()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Machine List
        let vc = MachineListController.instantiate(from: storyboard)
        vc.viewModel = MachineListViewModel(coordinator:  self, machineService: machineService)
        navigationController.pushViewController(vc, animated: false)
    }
    
}

extension AppCoordinator : MachineListRoutes, ScanRoutes, AddMachineRoutes, MachineDetailViewModelRoutes, EditMachineRoutes {
    
    func showWarningDialog(message: String) {
        let alert = UIAlertController.init(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func showEditPage(machineModel: ImageMachine) {
        let viewModel = EditMachineViewModel(currentData: machineModel, coordinator: self, service: machineService)
        let view = EditDetailSwiftUI(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMultiImagePicker(delegate : PHPickerViewControllerDelegate) {
        var pickerConfiguration = PHPickerConfiguration()
        pickerConfiguration.filter = .images
        pickerConfiguration.selectionLimit = 0
        
        let vc = PHPickerViewController.init(configuration: pickerConfiguration)
        vc.delegate = delegate
        navigationController.present(vc, animated: true, completion: nil)
        
    }
    
    func goToAddMachineList() {
        print("Add machine")
        let vc = AddMachineViewController.instantiate(from: storyboard)
        let model = AddMachineViewModel(coordinator: self, machineService: machineService)
        vc.viewModel = model
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCamera() {
        print("Go to Scan QR")
        let model = ScanViewModel(coordinator: self)
        let vc = ScanQRCodeViewController.instantiate(from: storyboard)
        vc.viewModel = model
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMachineDetail(machine : ImageMachine) {
        print("Go to Machine Detail \(machine.name ?? "-")")
        let model = MachineDetailViewModel(data: machine, coordinator: self, service: machineService)
        let view = MachineDetailSwiftUI(machineModel: model)
        let vc = UIHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showImage(image : UIImage, onDelete : @escaping (()->(Void))) {
        let popup = ImagePopupViewController.init(image: image)
        popup.onDeleteCallback = onDelete
        self.navigationController.present(popup, animated: true, completion: nil)
    }
}
