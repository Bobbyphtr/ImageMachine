//
//  AddMachineViewController.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 02/08/21.
//

import Combine
import UIKit

class AddMachineViewController: UIViewController, Storyboarded {
    
    var viewModel : AddMachineViewModel!

    @IBOutlet weak var machineNameField: UITextField!
    @IBOutlet weak var machineTypeField: UITextField!
    
    @IBOutlet weak var pickMachineImagesButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private var imageCollectionViewSubscriber : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Machine"
        
        configureViews()
        configureBindings()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func configureViews() {
        pickMachineImagesButton.layer.cornerRadius = 8.0
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: imageCollectionView.frame.width / 3, height: imageCollectionView.frame.width / 3)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        imageCollectionView.collectionViewLayout = layout
        
        let saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveMachine))
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func configureBindings(){
        
        imageCollectionViewSubscriber = viewModel.$thumbnailsCache
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink(receiveValue: { _ in
                self.imageCollectionView.reloadData()
            })
        
        machineNameField.addTarget(self, action: #selector(onTextFieldChanged(_:)), for: .editingChanged)
        machineTypeField.addTarget(self, action: #selector(onTextFieldChanged(_:)), for: .editingChanged)
        
    }
    
    @objc func onTextFieldChanged(_ sender : UITextField){
        switch sender {
        case machineNameField:
            viewModel.name = sender.text ?? ""
            break
        case machineTypeField:
            viewModel.type = sender.text ?? ""
            break
        default:
            break
        }
    }


    @IBAction func pickImages(_ sender: Any) {
        viewModel.pickImages()
    }
    
    @objc func saveMachine(){
        viewModel.saveMachine()
    }
}

extension AddMachineViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.thumbnailsCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        
        cell.image = viewModel.thumbnailsCache[indexPath.item]
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showImage(index: indexPath.item)
    }
    
}
