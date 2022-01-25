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
    var isFiltered = false
    var total = 0.0
    
    var userInfo : User!
    var address : Address!
    
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

            self.total = orders.reduce(0) { x, y in
                x + y.total
            }
            self.totalLbl.text = String(self.total)
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
        let order = isFiltered ? ordersFilter[indexPath.row] : orders[indexPath.row]
        
        Admin.shared.getUserService(serviceRef: order.serviceRef!) { service in
            vc.serviceNameLbl.text = service.name
        }
        
        vc.order = order
        vc.user = self.userInfo
        vc.address = self.address
        
        present(vc, animated: true, completion: nil)
        
    }
}
extension AdminHome: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
                return isFiltered ? ordersFilter.count : orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTVCell
        
        let order = isFiltered ? ordersFilter[indexPath.row] : orders[indexPath.row]
//        print("address DocID", order.addressRef?.documentID)
        Admin.shared.getUserDetail(userRef: order.userId) { user in
            self.userInfo = user
            
            
        }
        Admin.shared.getUserAddress(addressRef: order.addressRef!) { address in
            self.address = address
            cell.districLbl.text = self.address.district
        }
        cell.startedDateLbl.text = "\(order.date)"
        cell.userIDLbl.text = order.userId!.documentID
        cell.paymentState.text = order.paymentStatus ? "Paid" : "Unpaied"
        cell.totalLbl.text = "SAR \(order.total)"
        return cell
    }
    
}

//MARK: Collecton
extension AdminHome: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        
        ordersFilter.removeAll()
        isFiltered = true
        
        getFilteredOrder(index: indexPath.row) { orders in
            self.ordersFilter = orders
            self.ordersTV.reloadData()
        }
    }
    func getFilteredOrder(index: Int, complation: @escaping([Order])->Void){
//        ordersFilter.removeAll()
        var filterO = [Order]()
        orders.forEach { order in
            order.serviceRef?.getDocument(completion: { doc, err in
                guard let serviceName = doc?["name"] else { return }
                
                if serviceName as! String == self.services[index] {
                    filterO.append(order)
                    self.total = filterO.reduce(0) { x, y in
                        x + y.total
                    }
                    self.totalLbl.text = String(self.total)
                }
                complation(filterO)
            })
        }
    }
//    func test(){
//        print("i am here")
//        ordersFilter.removeAll()
//
//        for x in orders {
//            x.serviceId?.getDocument(completion: { DocumentSnapshot, error in
//
//                guard let data = DocumentSnapshot?.data() else {return}
//
//                if data["name"] as! String == self.services[self.index]{
//                    print(data["name"])
//
//                    self.isFiltered = true
//                    self.ordersFilter.append(x)
//                    self.ordersTV.reloadData()
//                }
//            })
//        }
//        print(self.ordersFilter)
//
//
//    }
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
