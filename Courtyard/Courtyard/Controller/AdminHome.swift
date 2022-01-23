//
//  AdminHome.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit
import FirebaseAuth


class AdminHome: UIViewController {
    
    var orders: [Order] = []
    var ordersFilter: [Order] = []
    var userInfo : User!
    var address : Address!
//    var service: Service!
    var services = ["Courtyard", "Roof of House", "Stairs"]
    var images: [UIImage?] = []
    
    @IBOutlet weak var serviceCollection: UICollectionView!
    @IBOutlet weak var ordersTV: UITableView!
    
    @IBOutlet weak var fromDP: UIDatePicker!
    @IBOutlet weak var toDP: UIDatePicker!
    @IBOutlet weak var totalLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let image1 = UIImage(named: "cortyard")
        let image2 = UIImage(named: "roof of house")
        let image3 = UIImage(named: "stairs")
        images = [image1, image2, image3]
        
        serviceCollection.delegate = self
        serviceCollection.dataSource = self
        
        
        ordersTV.delegate = self
        ordersTV.dataSource = self
        
        Admin.shared.getAllOrders() { orders in

            self.orders = orders
            self.ordersTV.reloadData()

        }
        
    }
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
// MARK: TableView
extension AdminHome: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "orderDetailsID") as! OrderDetails
        let order = self.orders[indexPath.row]
        
        vc.order = order
        vc.user = self.userInfo
        vc.address = self.address
        
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
//        self.navigationController?.show(vc, sender: nil)
    }
}
extension AdminHome: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTVCell
        
        let order = orders[indexPath.row]
        Admin.shared.getUserDetail(userRef: order.userId) { user in
            self.userInfo = user
            // TODO: fix address
            user.getAddresses { addresses,ref  in
                self.address = addresses.last
//                print("---------------User Address---------------")
//                print(self.address!)
                cell.districLbl.text = self.address!.district
            }
        }
        
        cell.userIDLbl.text = order.userId!.documentID
        cell.paymentState.text = order.paymentState ? "Paid" : "Unpaied"
        cell.totalLbl.text = "SAR \(order.total)"
        return cell
    }
    
    
}

//MARK: Collecton
extension AdminHome: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: filter table
        self.orders.removeAll()
        Admin.shared.filteredOrder(serviceTitle: services[indexPath.row]) { orders in
//                print(orders.count)
                
            self.orders = orders
            DispatchQueue.main.async {
                self.ordersTV.reloadData()
                print(orders.count)

            }
        }
        
    }
}
extension AdminHome: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCell
        cell.serviceImg.image = images[indexPath.row]
        cell.serviceName.text = services[indexPath.row]
        
        
        return cell
    }
    
    
}
