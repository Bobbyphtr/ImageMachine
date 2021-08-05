//
//  ViewController.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import UIKit
import Combine

class MachineListController: UITableViewController, Storyboarded {
    
    var viewModel : MachineListViewModel!
    
    var sortMenuActions : [UIAction] {
        return [
            UIAction(title: "By Name", image: UIImage(systemName: "textformat"), handler: { (_) in
            self.viewModel.sortName()
            }),
            UIAction(title: "By Type", image: UIImage(systemName: "square.grid.2x2.fill"), handler: { (_) in
                self.viewModel.sortType()
            })
        ]
    }
    
    private var listSubscriber : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Machine List"
        
        // Setup navigation buttons
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(onCameraButtonPressed))
        let sortButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "line.horizontal.3.decrease"), primaryAction: nil, menu: UIMenu(title: "Sort", image: nil, identifier: nil, options: [], children: sortMenuActions))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(onAddMachineButtonPressed))
        
        navigationItem.leftBarButtonItem = cameraButton
        navigationItem.rightBarButtonItems = [sortButton, addButton]
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureViews()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getAllMachine()
    }
    
    private func configureBindings(){
        // Sorting
        listSubscriber = viewModel.data.sink { _ in} receiveValue: { _ in
            self.tableView.reloadData()
        }
    }
    
    private func configureViews(){
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    @objc func onCameraButtonPressed(){
        viewModel.goToCamera()
    }
    
    @objc func onAddMachineButtonPressed(){
        viewModel.goToAddMachineList()
    }
    
    func onCellSelected(machineId : String){
        viewModel.goToMachineDetail(id: machineId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        onCellSelected(machineId: viewModel.data.value[indexPath.row].id)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MachineListTableViewCell.identifier, for: indexPath) as! MachineListTableViewCell
        cell.model = viewModel.data.value[indexPath.item]
        return cell
    }
}
