//
//  ImageStorageManager.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 01/08/21.
//

import Foundation
import UIKit

typealias OnCompletionWithSuccessCheck = (_ isSuccess : Bool)->Void

protocol ImageStorageService {
    func saveImages(with machineId : String, onCompletion : OnCompletionWithSuccessCheck?)
    func saveImage(with machineId : String, onCompletion : OnCompletionWithSuccessCheck?)
    func getImages(with machineId : String, onCompletion : ([UIImage]?) -> Void)
}

class ImageStorageManager : ImageStorageService {
    
    
    func saveImages(with machineId: String, onCompletion: OnCompletionWithSuccessCheck?) {
        <#code#>
    }
    
    func saveImage(with machineId: String, onCompletion: OnCompletionWithSuccessCheck?) {
        <#code#>
    }
    
    func getImages(with machineId: String, onCompletion: ([UIImage]?) -> Void) {
        <#code#>
    }
    

}
