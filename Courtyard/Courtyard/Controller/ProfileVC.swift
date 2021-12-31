//
//  ProfileVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//
// MARK: check imported library which one is not nesserry
import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class ProfileVC: UIViewController {
    
    var user: User!
    var service: Service!
    var addresses = [Address]()
    var db = Firestore.firestore()
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var addressesTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
//        print(user.name)
//        user.getData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addressesTV.delegate = self
        addressesTV.dataSource = self
        addressesTV.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "addressCell")
        
        
//         service is grapped from homeVC
        print("service: ", service ?? "unable to get data")
        let loginVC = LogIn()
        user = loginVC.user
        
//        user.getData()
        print("---------------user name--------------------")
//        print(user.name)
//        print(user.getData())
        fetchData()

        
    }
    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        performSegue(withIdentifier: "addressID", sender: self)
    }
    @IBAction func unWindToProfile (sender: UIStoryboardSegue){
        print("--------------- print form unWindToProfile--------------------")
        print(addresses)
        addressesTV.reloadData()
    }
    //
    @IBAction func OnClickBook(_ sender: UIButton){
        //        if address or service not exist display alert or message
        if service != nil && addresses.count != 0{
            
            sendDataToDB()
        }else{
            print("service is: \(service)")
        }
    }
    func sendDataToDB(){
        // Using reference
        
        //TODO: check service before add address
        // TODO: when add address store two addresses???
//        // store addresses in DB
//        var addressesRef : [DocumentReference] = []
//        for address in addresses {
//            let ref = (try? db.collection("Addresses").addDocument(from: address))!
//            addressesRef.append(ref)
//            print("address ref: \(ref)")
//        }
//
//        // store user in DB
//        user = User( name: nameTF.text!, mobile: Int(mobileTF.text!)!, addressesRef: addressesRef)
//        // Using current user as docoumentID then store field from instence of User
//        try? db.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: user)
        
        let userRef = user.storeUserDataInDB(name: nameTF.text, mobile: mobileTF.text, addresses: addresses)
        
        // store service in DB
        let serviceRef = try? db.collection("Service").addDocument(from: service)
        
        // create Order
        let order1 = Order(userId: userRef, serviceId: serviceRef, date: Date(), total: service!.price, paymentState: false)
        // store Orders in DB
        let orderRef1 = try? db.collection("Orders").addDocument(from: order1)
//        let ordersRef = [orderRef1!]
        
    }
    func fetchData(){
//        user.getData()
////        print("--------getData()----------")
////        print(userInfo)
//        let userD = User()
//
//        DispatchQueue.main.async {
//
//            print("-----------self.addresses----------")
//            print(self.addresses)
//            self.addressesTV.reloadData()
//        }
        
        // if current user equal Users/current display name, mobile and addresses
        
        db.collection("Users").document((Auth.auth().currentUser?.email!)!).addSnapshotListener { doc, err in
            if (err == nil){
                if doc?.exists != false{

                    self.user = try! doc?.data(as: User.self)
                    self.nameTF.text = self.user.name
                    self.mobileTF.text = "0\(String(describing: self.user.mobile!))"

                    // loop addresses from user Struct then store it in address model
                    if let addressesRef = self.user.addressesRef{

                        for addressID in addressesRef {

                            addressID.getDocument { addressDoc, err in
                                do {
                                    print("---------data---------")
                                    print(addressDoc?.data()!)
                                    if (err == nil){
                                        let address = try! addressDoc?.data(as: Address.self)
                                        print("---------address--------")
                                        print(address!)
                                        print("--------addressDoc?.documentID------")
                                        print(addressDoc?.documentID)

                                        self.addresses.append(address!)
                                        self.addressesTV.reloadData()
                                        print("---------self.addresses.last--------")
                                        print(self.addresses.last)
                                    }

                                }
                            }
                        }
                    }

                }

            }

        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: if address selected let user edit address
                if segue.identifier == "addressID"{
                    let addressVC = segue.destination as! AddressVC
                    addressVC.user = self.user
                }
    }
    
    
}

extension ProfileVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Order", message: "Are you sure you want to Order this service", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Order", style: .default, handler: { _ in
            
            //TODO: send date from model to Firestore
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension ProfileVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressesTV.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
        //        if addresses.count != 0 {
        
        let address = addresses[indexPath.row]
        cell.addressTypeLbl.text = address.street
        // cell.addressTypeLbl.text = "Building"
        cell.addressLbl.text = "\(address.buildingNo), \(address.street), \(String(describing: address.district!))"
        //        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
    
}

