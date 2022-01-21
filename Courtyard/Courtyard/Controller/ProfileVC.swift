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
    var address: Address!
    var addresses = [Address]()
    var addressesRef: [DocumentReference]?
    var primeAddress : Address!
    
    
    var orderRef : DocumentReference?
    var order: Order!
    var db = Firestore.firestore()
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var addressesTV: UITableView!
    
//    override func viewDidAppear(_ animated: Bool) {
//        print("---------------viewWillAppear--------------------")
//
//        print(service)
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
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
            self.addressesRef = user.addressesRef

            user.getAddresses { addresses,ref  in
//MARK: to avoid duplicated element : self.addresses.removeAll() before append element to array  Or asign the array to data directly
                self.addresses = addresses
                self.addressesRef = ref
                self.primeAddress = addresses.filter{$0.isPrime == true}.first
                self.addressesTV.reloadData()
                
            }
        })
    }
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        performSegue(withIdentifier: "addressID", sender: self)
    }
    
    @IBAction func unWindToProfile (sender: UIStoryboardSegue){
        print("--------------- print form unWindToProfile--------------------")
//        print(address)
        print(address ?? "no new address")
        fetchData()
    }
    
    @IBAction func OnClickBook(_ sender: UIButton){
        //  if address or service not exist display alert or message
        if service != nil && addresses.count != 0{
            
            sendDataToDB()
            showAlert("Your booking has been successfully completed")
        }else{
            print("service is: \(String(describing: service))")
            showAlert("Please choose the service first")
        }
    }
    func sendDataToDB(){

        user.storeUserDataInDB(name: nameTF.text, mobile: mobileTF.text)
        
        // asign order reference to orderRef and order
        (orderRef, order) = user.setOrder(service: service!, servicePrice: service!.price)
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.performSegue(withIdentifier: "orderID", sender: nil)
        }
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func changeAddressPrime(_ sender: UIButton){

        let index = sender.tag
        user.changePrimeAddress(for: addressesRef![index])
        sender.setImage(UIImage(systemName: "mappin.circle.fill"), for: .normal)
        print(addressesRef![index].documentID)
        
        // swap element value from index to inother
        addresses.swapAt(index, 0)
        addressesRef!.swapAt(index, 0)
        addressesTV.reloadData()

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: if address selected let user edit address
        switch segue.identifier{
        case "orderID":
            let paymentVC = segue.destination as! PaymentVC
            //ref, date, address, paymentState
            paymentVC.serviceTitle = service!.name + "Cleaning"
            paymentVC.orderRef = orderRef
            paymentVC.date = "\(String(describing: service!.date))"
            paymentVC.address = "\(String(describing: primeAddress.buildingNo)), \(String(describing: primeAddress.street)), \(String(describing: primeAddress.district!))"
            paymentVC.paymentState = order!.paymentState ? "Paied" : "Pending"
            paymentVC.price = order.total
        case "addressID":
            let addressVC = segue.destination as! AddressVC
            addressVC.user = self.user
        default:
            print("no data")
        }
//                if segue.identifier == "addressID"{
//                    let addressVC = segue.destination as! AddressVC
//                    addressVC.user = self.user
//                }
    }
    
    
}
// MARK: TableView
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
        cell.OnClickMappingCircle.tag = indexPath.row

        if indexPath.row != 0 {
                cell.OnClickMappingCircle.setImage(UIImage(systemName: "mappin.circle"), for: .normal)

            }else{
                cell.OnClickMappingCircle.setImage(UIImage(systemName: "mappin.circle.fill"), for: .normal)

            }
        
        
        cell.OnClickMappingCircle.addTarget(self, action: #selector(changeAddressPrime), for: .touchUpInside)
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    
}

