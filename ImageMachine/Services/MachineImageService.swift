//
//  MachineImageService.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 01/08/21.
//

import Foundation
import UIKit
import RealmSwift

typealias OnCompletionWithSuccessCheck = (_ isSuccess : Bool)->Void
typealias OnCompletionWithUIImage = (_ images : [UIImage])->Void

protocol MachineImageService {
    func saveMachine(machineImage : ImageMachine)
    func getMachine(with uuid : String) -> ImageMachine?
    func getAllMachine() -> [MachineListViewData]
    func updateMachine(name : String, type: String, maintenanceTime : Date, currentMachineImage : ImageMachine)
    func deleteMachine(with uuid : String)
    
    func saveImages(with machineId: String, images : [UIImage], onCompletion: OnCompletionWithSuccessCheck?)
    func getImages(imagePaths : [String], onCompletion: OnCompletionWithUIImage?)
    func removeImage(imageName : String, index : Int, currentImage : ImageMachine)
}

class MachineImageServiceImpl : MachineImageService {
    
    func saveMachine(machineImage : ImageMachine) {
        machineImage.imagePaths.append(objectsIn: saveImagesToFileSystem(machineId: machineImage._id, images: machineImage.images) ?? [])
        LocalStorageManager.add(machineImage)
    }
    
    func getMachine(with uuid : String) -> ImageMachine? {
        let result = LocalStorageManager.get(fromEntity: ImageMachine.self, withPredicate: NSPredicate(format: "_id == %@", uuid))
        return result.first
    }
    
    func getAllMachine() -> [MachineListViewData] {
        let results = LocalStorageManager.get(fromEntity: ImageMachine.self)
        return results.map { MachineListViewData(id: $0._id, name: $0.name ?? "", type: $0.type ?? "") }
    }
    
    func updateMachine(name : String, type: String, maintenanceTime : Date, currentMachineImage : ImageMachine) {
        LocalStorageManager.update(currentMachineImage) { mi in
            mi.lastMaintenance = maintenanceTime
            mi.name = name
            mi.type = type
        }
    }
    
    func deleteMachine(with uuid : String) {
        LocalStorageManager.delete(fromEntity: ImageMachine.self, withPredicate: NSPredicate(format: "_id == %@", uuid))
        deleteImagesRelatedToMachine(uuid: uuid)
        
    }
    
    func saveImages(with machineId: String, images : [UIImage], onCompletion: OnCompletionWithSuccessCheck?) {
        print("Saving \(images.count) images")
        let result = LocalStorageManager.get(fromEntity: ImageMachine.self, withPredicate: NSPredicate(format: "_id == %@", machineId))
        if let currentImage = result.first {
            LocalStorageManager.update(currentImage) { mi in
                mi.imagePaths.removeAll()
                mi.imagePaths.append(objectsIn: self.saveImagesToFileSystem(machineId: machineId, images: images) ?? [])
                onCompletion?(true)
            }
        }
    }
    
    func removeImage(imageName : String, index : Int, currentImage : ImageMachine){
        deleteImageFromImageName(name: imageName)
        
        LocalStorageManager.update(currentImage) { mi in
            mi.imagePaths.remove(at: index)
        }
        
    }
    
    func getImages(imagePaths: [String], onCompletion: OnCompletionWithUIImage?) {
        var result : [UIImage] = []
        for imgName in imagePaths {
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let image = UIImage.init(contentsOfFile: documentPath.appendingPathComponent(imgName).path)!
            result.append(image)
        }
        onCompletion?(result)
    }

}

extension MachineImageServiceImpl {
    
    /// Save Images to file system
    /// - Parameter images: List of images
    /// - Returns: List of URLs
    func saveImagesToFileSystem(machineId : String, images : [UIImage]) -> [String]?{
        var result = [String]()
        
        guard let documentsPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        for image in images {
            let imageName = "\(machineId)_\(Int.random(in: 0...9999)).jpg"
            let path = documentsPath.appendingPathComponent(imageName)
            if let imgData = image.jpegData(compressionQuality: 0.4) {
                do{
                    try imgData.write(to: path)
                    print("Written image to path \(path)")
                    result.append(imageName)
                } catch {
                    print("Image failed to save \(error.localizedDescription)")
                }
            }
        }
        
        return result
    }
    
    /// Delete all images with machine UUID
    /// - Parameter uuid: machine id
    func deleteImagesRelatedToMachine(uuid : String) {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let enumerator = FileManager.default.enumerator(atPath: documentsPath.path)
        let filePaths = enumerator?.allObjects as! [String]
        let scanItems = filePaths.filter { str in
            if str.contains(uuid) {
                print(str)
                return true
            }
            return false
        }
        
        for item in scanItems {
            do {
                try FileManager.default.removeItem(atPath: documentsPath.appendingPathComponent(item).path)
            } catch {
                print("Cant delete this folder. \(error)")
            }
            
        }
    }
    
    func deleteImageFromImageName(name : String) {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let enumerator = FileManager.default.enumerator(atPath: documentsPath.path)
        let filePaths = enumerator?.allObjects as! [String]
        let scanItems = filePaths.filter { str in
            if str == name {
                print(str)
                return true
            }
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: documentsPath.appendingPathComponent(scanItems.first!).path)
            print("Removed image \(scanItems.first ?? "")")
        } catch {
            print("Cant delete this folder. \(error)")
        }
       
    }
}
