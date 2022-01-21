//
//  PaymentVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit
import FirebaseFirestore

class PaymentVC: UIViewController {

    var date, address, paymentState : String?
    var orderRef: DocumentReference?
    var price : Double = 0
    var serviceTitle = ""
    
    @IBOutlet weak var serviceTitleLbl: UILabel!
    @IBOutlet weak var orderRefLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var paymentStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serviceTitleLbl.text = serviceTitle
        orderRefLbl.text = orderRef?.documentID
        dateLbl.text = date!
        currentAddress.text = address!
        PriceLbl.text = "SAR \(price)"
        paymentStatus.text = paymentState!
    }
    @IBAction func onClickPay(_ sender: UIButton) {
        // when client pay: update data in DB
        showAlert("Are you sure you want Pay for \(serviceTitle)")
        
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Payment", message: msg, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Pay", style: .destructive) { _ in
            self.orderRef?.setData(["paymentState" : true], merge: true)
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
