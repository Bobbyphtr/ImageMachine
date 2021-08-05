//
//  ImageCollectionViewCell.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 02/08/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCell"
    
    var image : UIImage? {
        didSet {
            imageView.image = image
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func configureViews(){
        backgroundContainer.clipsToBounds = true
        backgroundContainer.layer.cornerRadius = 8.0
    }

}
