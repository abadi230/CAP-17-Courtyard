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
        serviceTitleLbl.text = NSLocalizedString(serviceTitle, comment: "")
        orderRefLbl.text = orderRef?.documentID
        dateLbl.text = date!
        currentAddress.text = address!
        PriceLbl.text = "SAR \(price)"
        paymentStatus.text = paymentState!
    }
    @IBAction func onClickPay(_ sender: UIButton) {
        // when client pay: update data in DB
        let msg = NSLocalizedString("Are you sure you want Pay for", comment: "")
        showAlert("\(msg) \(NSLocalizedString(serviceTitle, comment: ""))")
        
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Payment", message: msg, preferredStyle: .alert)

        let alertAction = UIAlertAction(title: NSLocalizedString("Pay", comment: ""), style: .destructive) { _ in
            self.orderRef?.setData(["paymentStatus" : true], merge: true)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
