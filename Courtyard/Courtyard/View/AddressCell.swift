//
//  AddressCell.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 25/12/2021.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var addressTypeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
