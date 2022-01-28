//
//  UserOrdersCell.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 28/01/2022.
//

import UIKit

class UserOrdersCell: UITableViewCell {

    @IBOutlet weak var orderRef: UILabel!
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var startedDate: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
