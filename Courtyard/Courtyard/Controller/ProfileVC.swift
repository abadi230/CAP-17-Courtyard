//
//  ProfileVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class ProfileVC: UIViewController {

    var user: User?
    var service: Service?
    var addresses = [Address]()
    var db = Firestore.firestore()
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    
    @IBOutlet weak var addressesTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        addressesTV.reloadData()
        print(addresses.count)
        // check address passed from addressVC
        print("Address: \(addresses)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressesTV.delegate = self
        addressesTV.dataSource = self
        addressesTV.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "addressCell")
//        addressesTV.register("AddressCell", forCellReuseIdentifier: "addressCell")
        
        // check address passed from addressVC
        print("Address: \(addresses)")
        
        // service is grapped from homeVC
        print("service: ", service ?? "unable to get data")
        
        //TODO: send date from model to Firestore
    }
    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        performSegue(withIdentifier: "addressID", sender: self)
    }
    @IBAction func unWindToProfile (sender: UIStoryboardSegue){
        
        print(addresses)
        addressesTV.reloadData()
    }
//    
    
    func fetchUsers(){
        db.collection("Users").addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil  else {
                print("No Documnets")
                return
            }
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: if address selected let user edit address
//        if segue.identifier == "addressID"{
//            let addressVC = segue.destination as! AddressVC
//            addressVC.addresses = addresses
//        }
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
            cell.addressLbl.text = "Buildein No.:\(address.buildingNo), Street: \(address.street), Districit: \(String(describing: address.district))"
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    
    
}
