//
//  OrderTVCell.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit

class OrderTVCell: UITableViewCell {

    @IBOutlet weak var districLbl: UILabel!
    @IBOutlet weak var userIDLbl: UILabel!
    @IBOutlet weak var startedDateLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var paymentState: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
