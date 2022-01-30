//
//  AdminHome.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 03/01/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class AdminHome: UIViewController {
    
    var orders: [Order] = []
    var ordersRef: [DocumentReference] = []
    var ordersFilter: [Order] = []
    var isFiltered = false
    var total = 0.0
    let currency = NSLocalizedString("SAR", comment: "")
    var userInfo : User!
    var address : Address!
    var services = ["Courtyard Cleaning", "Roof of House Cleaning", "Stairs Cleaning"]
    var images: [UIImage?] = []
    
    @IBOutlet weak var serviceCollection: UICollectionView!
    @IBOutlet weak var ordersTV: UITableView!
    @IBOutlet weak var fromDP: UIDatePicker!
    @IBOutlet weak var toDP: UIDatePicker!
    @IBOutlet weak var totalLbl: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        displayVC()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image1 = UIImage(named: "cortyard")
        let image2 = UIImage(named: "roof of house")
        let image3 = UIImage(named: "stairs")
        images = [image1, image2, image3]
        
        serviceCollection.delegate = self
        serviceCollection.dataSource = self
        
        
        ordersTV.delegate = self
        ordersTV.dataSource = self
        
        displayVC()
    }
    
    @IBAction func fromDPAction(_ sender: UIDatePicker) {
        FilterDate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toDPAction(_ sender: UIDatePicker) {
        FilterDate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    func displayVC(){
        Admin.shared.getAllOrders() { orders, ordersRef  in

            self.orders = orders
            self.ordersRef = ordersRef

            self.total = orders.reduce(0) { x, y in
                x + y.total
            }
            self.totalLbl.text = String(format: "%.2f", self.total)
            
            self.ordersTV.reloadData()
        }
    }
    // filter depends on service
    func getFilteredOrder(index: Int, complation: @escaping([Order])->Void){

        var filterO = [Order]()
        orders.forEach { order in
            order.serviceRef?.getDocument(completion: { doc, err in
                guard let serviceName = doc?["name"] else { return }
                
                if serviceName as! String == self.services[index].LocalizableLanguage(name: "en") {
                    filterO.append(order)
                    self.total = filterO.reduce(0) { x, y in
                        x + y.total
                    }
                    self.totalLbl.text = "\(self.currency) \(String(format: "%.2f", self.total))"
                }
                complation(filterO)
            })
        }
    }
    
    // filter depends on Date
    func FilterDate(){
        let newfilter = isFiltered ? ordersFilter : orders
        
        let sortedOrder = newfilter.sorted(by: { x, y in
            x.date < y.date
        })
        ordersFilter = sortedOrder.filter { order in
            let from = fromDP.date.formatted(date: .numeric, time: .omitted)
            let to = toDP.date.formatted(date: .numeric, time: .omitted)
            let orderDate = order.date.formatted(date: .numeric, time: .omitted)
            
            return orderDate >= from && orderDate <= to
        }
        isFiltered = true
        ordersTV.reloadData()
    }
}
// MARK: TableView
extension AdminHome: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "orderDetailsID") as! OrderDetails
        let order = isFiltered ? ordersFilter[indexPath.row] : orders[indexPath.row]
        let orderRef = ordersRef[indexPath.row]
        Admin.shared.getUserService(serviceRef: order.serviceRef!) { service in
            vc.serviceNameLbl.text = NSLocalizedString(service.name, comment: "")
        }
        
        vc.order = order
        vc.user = self.userInfo
        vc.address = self.address
        vc.orderRef = orderRef
        
        navigationController?.show(vc, sender: nil)
        ordersTV.deselectRow(at: indexPath, animated: true)
        
    }
}
extension AdminHome: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFiltered ? ordersFilter.count : orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTVCell
        
        let order = isFiltered ? ordersFilter[indexPath.row] : orders[indexPath.row]

        Admin.shared.getUserDetail(userRef: order.userId) { user in
            self.userInfo = user
            
            
        }
        Admin.shared.getUserAddress(addressRef: order.addressRef!) { address in
            self.address = address
            cell.districLbl.text = self.address.district
        }
        cell.startedDateLbl.text = "\(order.date.formatted(date: .abbreviated, time: .shortened))"
        cell.userIDLbl.text = order.userId!.documentID
        cell.paymentState.text = order.paymentStatus ? NSLocalizedString("Paid", comment: "") : NSLocalizedString("Unpaied", comment: "")
        
        cell.totalLbl.text = "\(currency) \(order.total)"
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
}


extension AdminHome: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCell
        cell.serviceImg.image = images[indexPath.row]
        
        return cell
    }
}
