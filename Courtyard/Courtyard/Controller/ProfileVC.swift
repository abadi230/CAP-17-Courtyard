//
//  ProfileVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//
// MARK: check imported library which one is not nesserry
import UIKit
import Firebase
//import FirebaseCore
//import FirebaseFirestore
import FirebaseFirestoreSwift


class ProfileVC: UIViewController {
    
    var user = User()
    var service: Service!
    var address: Address?
    var addresses = [Address]()
    var db = Firestore.firestore()
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var addressesTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("---------------viewWillAppear--------------------")

        fetchData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchData()
        
        // Do any additional setup after loading the view.
        addressesTV.delegate = self
        addressesTV.dataSource = self
        addressesTV.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "addressCell")
        
        print("---------------didLoad--------------------")
//         service is grapped from homeVC
        print("service: ", service ?? "unable to get data")
        print("addresses: ", addresses)
    }
    
    func fetchData(){
        //from DB
        user.getDataClosure(completion: { user  in
            self.nameTF.text = user.name
            self.mobileTF.text = "0\(String(describing: user.mobile!))"

            user.getAddresses { addresses in
                self.addresses = addresses
                self.addressesTV.reloadData()
            }
        })
    }
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        performSegue(withIdentifier: "addressID", sender: self)
    }
    
    @IBAction func unWindToProfile (sender: UIStoryboardSegue){
        print("--------------- print form unWindToProfile--------------------")
        print(address)

    }
    
    @IBAction func OnClickBook(_ sender: UIButton){
        //        if address or service not exist display alert or message
        if service != nil && addresses.count != 0{
            
            sendDataToDB()
            showAlert("Your booking has been successfully completed")
        }else{
            print("service is: \(String(describing: service))")
            showAlert("Please choose the service first")
        }
    }
    func sendDataToDB(){
        // Using reference
        
        //TODO: check service before add address
        // TODO: when add address store two addresses???

        
        let userRef = user.storeUserDataInDB(name: nameTF.text, mobile: mobileTF.text)
        
        // store service in DB
        let serviceRef = try? db.collection("Service").addDocument(from: service)
        
        // create Order
        let order1 = Order(userId: user.userReference(), serviceId: serviceRef, date: Date(), total: service!.price, paymentState: false)
        // store Orders in DB
        let orderRef1 = try? db.collection("Orders").addDocument(from: order1)
//        let ordersRef = [orderRef1!]
        
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
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
        
        let address = addresses[indexPath.row]
        cell.addressTypeLbl.text = address.type
        cell.addressLbl.text = "\(address.buildingNo), \(address.street), \(String(describing: address.district!))"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
    
}

