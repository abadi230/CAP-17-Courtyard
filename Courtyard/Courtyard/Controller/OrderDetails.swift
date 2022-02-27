//
//  OrderDetails.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit
import FirebaseFirestore

class OrderDetails: UIViewController {

    var order: Order!
    var orderRef : DocumentReference!
    var user: User!
    var address: Address!
    var service: Service!
    var serviceTitle = ""
    let paied = NSLocalizedString("Paied", comment: "")
    let unPaied = NSLocalizedString("Unpaid", comment: "")
    let complated = NSLocalizedString("Complated", comment: "")
    let pending = NSLocalizedString("Pending", comment: "")
    
    // MARK: Connection
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var orderRefLbl1: UILabel!
    
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var startDateLbl : UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var serviceStatusLbl: UILabel!
    @IBOutlet weak var orderRefLbl: UILabel!
    
    @IBOutlet weak var paymentSwitch: UISwitch!
    @IBOutlet weak var orderSwitch: UISwitch!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        displayVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayVC()
        
        
    }
    
    @IBAction func onClickOrderSwitch(_ sender: UISwitch) {
        orderRef.setData(["status" : true], merge: true)
        serviceStatusLbl.text = complated
        sender.isUserInteractionEnabled = false
    }
    func displayVC(){
        orderRefLbl1.text = NSLocalizedString("Order Ref", comment: "")
        orderRefLbl.text = orderRef.documentID
        serviceNameLbl.text = serviceTitle
        userNameLbl.text = user.name
        mobileLbl.text = "0\(user.mobile!)"
        addressLbl.text = address.district
        
        priceLbl.text = "SAR \(order.total)"
        
        paymentStatusLbl.text = order.paymentStatus ? paied : unPaied
        paymentSwitch.setOn(order.paymentStatus ? true : false, animated: true)
        if order.paymentStatus {paymentSwitch.isUserInteractionEnabled = false}
        
        orderSwitch.setOn(order.status ? true : false, animated: true)
        serviceStatusLbl.text = order.status ? complated : pending
        if order.status {orderSwitch.isUserInteractionEnabled = false}

        Admin.shared.getUserService(serviceRef: order.serviceRef!) { service in
            
            self.serviceNameLbl.text = NSLocalizedString(service.name, comment: "")
            self.startDateLbl.text = service.date.formatted(date: .abbreviated, time: .shortened)
        }
    }
    @IBAction func onRightSwipe(_ sender: UISwipeGestureRecognizer){
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickPaymentSwitch(_ sender: UISwitch) {
            orderRef!.setData(["paymentStatus" : true], merge: true)
            sender.isUserInteractionEnabled = false
            paymentStatusLbl.text =  paied
    }
}
