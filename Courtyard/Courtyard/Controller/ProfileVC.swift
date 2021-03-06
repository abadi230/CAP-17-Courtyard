//
//  ProfileVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//
// MARK: check imported library which one is not nesserry
import UIKit
import Firebase
import FirebaseFirestoreSwift


class ProfileVC: UIViewController {
    
    var user = User()
    var service: Service!
    var address: Address?
    var addressRef: DocumentReference!
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
    
    override func viewDidAppear(_ animated: Bool) {
//        fetchData()
        print("viewDidAppear")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.hidesBackButton = true
        addressesTV.delegate = self
        addressesTV.dataSource = self
        addressesTV.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "addressCell")
        

//        print("---------------didLoad--------------------")
////         service is grapped from homeVC
//        print("service: ", service ?? "unable to get data")
//        print("addresses: ", addresses)

    }
    
    func fetchData(){
        //from DB
        user.getDataClosure(completion: { user  in
            self.nameTF.text = user.name
            self.mobileTF.text = "0\(String(describing: user.mobile!))"
            self.addressesRef = user.addressesRef

            user.getAddresses { addresses,ref,primeRef   in
//MARK: to avoid duplicated element : self.addresses.removeAll() before append element to array  Or asign the array to data directly
//                self.addresses = addresses
                self.addressesRef = ref
                self.primeAddress = addresses.filter{$0.isPrime == true}.first
                self.addresses = addresses
                self.addressRef = primeRef
                self.addressesTV.reloadData()
            }
        })
        
    }
    @IBAction func onRightSwipe(_ sender: UISwipeGestureRecognizer){
        let homeVC = (storyboard?.instantiateViewController(withIdentifier: "tabID"))!
        homeVC.modalPresentationStyle = .fullScreen

//        let vc = tabBarController?.viewControllers![2]
        present(homeVC, animated: true, completion: nil)
        
        
    }
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        performSegue(withIdentifier: "addressID", sender: self)
    }
    
    @IBAction func unWindToProfile (sender: UIStoryboardSegue){
        print("--------------- print form unWindToProfile--------------------")
//        print(address)
        print(address ?? "no new address")
        user.addAddressToDB(address: address, complation: { addressRef in
            self.addressRef = addressRef
        })
        fetchData()
//        addressRef = user.addressesRef?.last
    }
    
    @IBAction func OnClickBook(_ sender: UIButton){
        //  if address or service not exist display alert or message
        if service != nil && addresses.count != 0{
            
            sendDataToDB()
            showAlert("Your booking has been successfully completed")
        }else{
            var msg = ""
            if service == nil {
                msg = "Please choose the service first"
            }
            if primeAddress == nil { msg = "Please Add Address first"}
            
            showAlert(msg)
        }
    }
    func sendDataToDB(){
        user.storeUserDataInDB(name: nameTF.text, mobile: mobileTF.text)
        
        // asign order reference to orderRef and order
        if let service = service{

            (orderRef, order) = user.setOrder(service: service, servicePrice: service.price, addressRef: addressRef)
        }
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: nil, message: NSLocalizedString(msg, comment: ""), preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { [self] _ in
            if service != nil && primeAddress != nil{
                self.performSegue(withIdentifier: "orderID", sender: nil)
            }
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
        primeAddress = addresses.first
        addressRef = addressesRef?.first
        addressesTV.reloadData()

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: if address selected let user edit address
        switch segue.identifier{
        case "orderID":
            let paymentVC = segue.destination as! PaymentVC
            
            paymentVC.serviceTitle = service!.name
            paymentVC.orderRef = orderRef
            paymentVC.date = service.date.formatted(date: .abbreviated , time: .shortened)
            paymentVC.address = "\(String(describing: primeAddress.buildingNo)), \(String(describing: primeAddress.street)), \(String(describing: primeAddress.district!))"
            paymentVC.paymentState = order!.paymentStatus ? NSLocalizedString("Paied", comment: "") : NSLocalizedString("Pending", comment: "")
            paymentVC.price = order.total
        case "addressID":
            let addressVC = segue.destination as! AddressVC
            addressVC.user = self.user
        default:
            print("no data")
        }
    }
    
    
}
// MARK: TableView
extension ProfileVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "")) { action, view, completionHandler in
            //remove address reference from User class and collection also remove address form Addresses collection
            self.user.removeAddress(addressRef: self.addressesRef![indexPath.row])
            // remove address from table view
            self.addresses.remove(at: indexPath.row)
            self.addressesTV.reloadData()
            completionHandler(true)
        }
       
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
}

