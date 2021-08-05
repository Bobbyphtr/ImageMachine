//
//  ImageMachine.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation
import UIKit
import RealmSwift

class ImageMachine : Object {
    @Persisted(primaryKey: true) var _id : String = UUID().uuidString
    @Persisted var name : String? = nil
    @Persisted var type : String? = nil
    @Persisted var qrCodeNumber : Int = Int.random(in: 0...9999)
    @Persisted var lastMaintenance : Date? = nil
    
    @Persisted var imagePaths : List<String> = List<String>()
    
    var images : [UIImage] = []
    
    convenience init(name : String, type : String, images : [UIImage]) {
        self.init()

        self.name = name
        self.type = type
        self.images = images
        self.lastMaintenance = Date()
    }
}
