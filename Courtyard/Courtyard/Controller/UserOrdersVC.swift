//
//  UserOrdersVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 28/01/2022.
//

import UIKit
import FirebaseAuth
import SwiftUI

class UserOrdersVC: UIViewController {

    var user = User()
    var userOrders: [Order] = []
    var ordersRef: [String] = []
    @IBOutlet weak var userOrdersTV: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        userOrdersTV.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)

        user.getDataClosure { user in
            let userID = user.userReference().documentID
            user.getUserOrders(userId: userID) { orders,ordersRef  in
                self.userOrders = orders
                self.ordersRef = ordersRef
                self.userOrdersTV.reloadData()
            }
        }
    }
    


}
extension UserOrdersVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userOrdersTV.deselectRow(at: indexPath, animated: true)
    }
}
extension UserOrdersVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userOrders.count
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userOrdersTV.dequeueReusableCell(withIdentifier: "UserOrdersCell", for: indexPath) as! UserOrdersCell
        
        let order = userOrders[indexPath.row]
        let orderId = ordersRef[indexPath.row]

        Admin.shared.getUserService(serviceRef: order.serviceRef!) { service in
            cell.serviceTitle.text = NSLocalizedString(service.name, comment: "")
            cell.startedDate.text = service.date.formatted(date: .abbreviated, time: .shortened)
        }

        cell.orderRef.text = orderId
        cell.orderStatus.text = order.status ? NSLocalizedString("Accepted", comment: "") : NSLocalizedString("Pending", comment: "")
        return cell
    }
    
    
}
