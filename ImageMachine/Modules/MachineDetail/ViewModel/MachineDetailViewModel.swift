//
//  MachineDetailViewModel.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 02/08/21.
//

import Foundation
import UIKit
import PhotosUI
import Combine

protocol MachineDetailViewModelRoutes : AppFlow {
    func showMultiImagePicker(delegate : PHPickerViewControllerDelegate)
    func showImage(image : UIImage, onDelete : @escaping (()->(Void)))
    func showEditPage(machineModel : ImageMachine)
    func goBack()
}

class MachineDetailViewModel : ObservableObject {
    
    // coordinator
    private var coordinator : MachineDetailViewModelRoutes!
    
    // service
    private var service : MachineImageService!
    
    // input
    @Published private var data : ImageMachine!
    
    // Output
    @Published var name : String = ""
    @Published var maintenanceDate : Date = Date()
    @Published var id : String = "#"
    @Published var type : String = "-"
    @Published var qrCodeNumber : String = "-"
    
    var thumbnailImages : CurrentValueSubject<[UIImage], Error> = CurrentValueSubject([])
    
    var originalImages : [UIImage] = []
    
    init(data : ImageMachine, coordinator : MachineDetailViewModelRoutes, service : MachineImageService) {
        self.data = data
        self.coordinator = coordinator
        self.service = service
        
        updateMachine()
        
        fetchImages()
    
    }
    
    func updateMachine(){
        self.name = data.name ?? ""
        self.maintenanceDate = data.lastMaintenance ?? Date()
        self.id = "#\(data._id)"
        self.type = data.type ?? ""
        self.qrCodeNumber = "\(data.qrCodeNumber)"
        self.originalImages = data.images
        self.data = data
        
    }
    
    func fetchImages(){
        data.images = []
        self.originalImages = []
        service.getImages(imagePaths: data.imagePaths.map { $0 }) { images in
            self.data.images = images
            self.originalImages = self.data.images
            let thumbnails = self.originalImages.map { $0.generateThumbnail() }
            self.thumbnailImages.send(thumbnails)
        }
    }
    
    func showImagePicker(){
        coordinator.showMultiImagePicker(delegate: self)
    }
    
    func showImage(index : Int){
        var thumnails = self.thumbnailImages.value.map { $0 }
        coordinator.showImage(image: originalImages[index]) {
            thumnails.remove(at: index)
            self.originalImages.remove(at: index)
            self.service.removeImage(imageName: self.data.imagePaths[index], index: index, currentImage: self.data)
            self.thumbnailImages.send(thumnails)
        }
    }
    
    func saveImages(){
        service.saveImages(with: data._id, images: originalImages) { isSuccess in
            if isSuccess {
                print("Images saved")
                self.updateMachine()
            }
        }
    }
    
    func editMachine(){
        coordinator.showEditPage(machineModel: data)
    }
    
    func deleteMachine(){
        service.deleteMachine(with: data._id)
        coordinator.goBack()
    }
}

extension MachineDetailViewModel : PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
       
        for item in results {
            group.enter()
            item.itemProvider
                .loadObject(ofClass: UIImage.self) { object, error in
                    guard error == nil else {
                        print(error?.localizedDescription ?? "unknown error")
                        return
                    }
                    
                    let image = object as! UIImage
                    DispatchQueue.main.async {
                        self.thumbnailImages.value.append(image.generateThumbnail())
                        self.originalImages.append(image)
                        group.leave()
                    }
                    
                }
        }
        group.notify(queue: .main) {
            print("Saving image")
            self.saveImages()
        }
    }
    
}
