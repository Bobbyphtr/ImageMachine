//
//  AddMachineViewModel.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 02/08/21.
//

import Foundation
import PhotosUI
import QuickLook
import QuickLookThumbnailing
import Combine

protocol AddMachineRoutes : AppFlow {
    func goBack()
    func showMultiImagePicker(delegate : PHPickerViewControllerDelegate)
    func showImage(image : UIImage, onDelete : @escaping (()->(Void)))
}

class AddMachineViewModel {
    
    let coordinator : AddMachineRoutes!
    let machineService : MachineImageService!
    
    // Input
    var name : String = ""
    var type : String = ""
    
    @Published var thumbnailsCache : [UIImage] = []
    var originalImage : [UIImage] = []
    
    init(coordinator : AddMachineRoutes, machineService : MachineImageService) {
        self.coordinator = coordinator
        self.machineService = machineService
    }
    
    func saveMachine() {
        if !name.isEmpty && !type.isEmpty {
            let newMachine = ImageMachine(name: name, type: type, images: originalImage)
            machineService.saveMachine(machineImage: newMachine)
            coordinator.goBack()
        } else {
            coordinator.showWarningDialog(message: "Please fill all empty fields")
        }
    }
    
    func cancelAdd(){
        coordinator.goBack()
    }
    
    func pickImages(){
        coordinator.showMultiImagePicker(delegate: self)
    }
    
    func showImage(index : Int){
        self.coordinator.showImage(image: originalImage[index]) {
            self.thumbnailsCache.remove(at: index)
            self.originalImage.remove(at: index)
        }
    }

}

extension AddMachineViewModel : PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        for item in results {
            item.itemProvider
                .loadObject(ofClass: UIImage.self) { object, error in
                    guard error == nil else {
                        print(error?.localizedDescription ?? "unknown error")
                        return
                    }
                    
                    let image = object as! UIImage
                    self.thumbnailsCache.append(image.generateThumbnail())
                    self.originalImage.append(image)
                }
        }
            
        
    }
    
}
