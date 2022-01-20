//
//  PaymentVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit

class PaymentVC: UIViewController {

    var ref, date, address, paymentState : String?
    var price : Double = 0
    var serviceTitle = ""
    
    @IBOutlet weak var serviceTitleLbl: UILabel!
    @IBOutlet weak var orderRef: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var paymentStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serviceTitleLbl.text = serviceTitle
        orderRef.text = ref!
        dateLbl.text = date!
        currentAddress.text = address!
        PriceLbl.text = "SAR \(price)"
        paymentStatus.text = paymentState!
    }
    @IBAction func onClickPay(_ sender: UIButton) {
        // when client pay: update data in DB
        
    }
    

}
