//
//  OrderDetails.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit

class OrderDetails: UIViewController {

    var order: Order!
    var user: User!
    var address: Address!
    var service: Service!
    var serviceTitle = ""
    // MARK: Connection
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var startDateLbl : UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var serviceStatusLbl: UILabel!
    
    @IBOutlet weak var paymentSwitch: UISwitch!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        Admin.shared.getUserService(serviceRef: order.serviceId!) { service in
            
//            self.serviceNameLbl.text = service.name
//        }
        self.serviceNameLbl.text = serviceTitle
        userNameLbl.text = user.name
        mobileLbl.text = "0\(user.mobile!)"
        addressLbl.text = address.district
        
        
        
        priceLbl.text = "SAR \(order.total)"
        paymentStatusLbl.text = order.paymentStatus ? "Paied" : "Unpaid"
        serviceStatusLbl.text = "Complated"
//        paymentSwitch
    }
    @IBAction func onRightSwipe(_ sender: UISwipeGestureRecognizer){
        let vc = (storyboard?.instantiateViewController(withIdentifier: "AdminHome"))!
        vc.modalPresentationStyle = .fullScreen
//        navigationController?.show(vc, sender: self)
        present(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
