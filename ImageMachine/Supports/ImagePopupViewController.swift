//
//  ImagePopupViewController.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 03/08/21.
//

import UIKit

class ImagePopupViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage : UIImage?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    
    var onDeleteCallback : (()->Void)?
    
    convenience init(image : UIImage) {
        self.init()
        
        currentImage = image
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = currentImage
        
    }

    @IBAction func removeImageButton(_ sender: Any) {
        onDeleteCallback?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
