//
//  ImageMachine.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation
import UIKit

class ImageMachine {
    var id : Int!
    var name : String?
    var type : String?
    var qrCodeNumber : Int?
    var lastMaintenance : Date?
    
    var images : [UIImage] = []
    
    init(name : String, type : String, images : [UIImage]) {
        self.name = name
        self.type = type
        self.images = images
    }
}
