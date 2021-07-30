//
//  Coordinator.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var navigationController : UINavigationController! { get set }
    
    init(navigationController : UINavigationController)
    
    func start()
    
   
}
