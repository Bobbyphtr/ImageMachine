//
//  MachineListTableViewCell.swift
//  ImageMachine
//
//  Created by BobbyPhtr on 30/07/21.
//

import UIKit

class MachineListTableViewCell: UITableViewCell {
    
    var model : MachineListViewData? {
        didSet {
            self.nameLabel.text = model?.name
            self.typeNameLabel.text = model?.type
            self.machineID = model?.id
        }
    }
    
    @IBOutlet weak var cardBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    
    static let identifier = "MachineListCell"
    
    var machineID : String!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews(){
        cardBackground.backgroundColor = .white
        
        cardBackground.layer.cornerRadius = 16.0
        cardBackground.layer.shadowColor = UIColor.darkGray.cgColor
        cardBackground.layer.shadowRadius = 6
        cardBackground.layer.shadowOpacity = 0.3
        cardBackground.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

}
