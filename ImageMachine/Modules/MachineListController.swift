//
//  ViewController.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import UIKit

class MachineListController: UITableViewController, Storyboarded {
    
    var viewModel : MachineListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Machine List"
        
        // Setup navigation buttons
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(onCameraButtonPressed))
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"), style: .plain, target: self, action: #selector(onFilterButtonPressed))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(onAddMachineButtonPressed))
        
        navigationItem.leftBarButtonItem = cameraButton
        navigationItem.rightBarButtonItems = [sortButton, addButton]
        
        configureViews()
    }
    
    private func configureViews(){
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    @objc func onCameraButtonPressed(){
        viewModel.goToCamera()
    }
    
    @objc func onFilterButtonPressed(){
        print("Filter Button PRessed")
    }
    
    @objc func onAddMachineButtonPressed(){
        print("Add Machine PRessed")
    }
    
    func onCellSelected(machineName : String){
        viewModel.goToMachineDetail(machine: machineName)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelected(machineName: viewModel.data[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MachineListTableViewCell.identifier, for: indexPath) as! MachineListTableViewCell
        
        cell.model = MachineListDataModel(machineName: viewModel.data[indexPath.row])
        
        return cell
    }
}

