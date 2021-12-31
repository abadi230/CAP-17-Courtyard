//
//  AddressVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 18/12/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddressVC: UIViewController{
    var db = Firestore.firestore()
    var user : User?
    var newAddress : Address?
    
    
    @IBOutlet weak var addressType: UITextField!
    @IBOutlet weak var buildingNoTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var districtTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var additionalNoTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        // send data to Address
        //        let building = Int(buildingNoTF.text!)!
        //        let zip = Int(zipTF.text!)
        //        let addition = Int(additionalNoTF.text!)
        
        
        //        fetchData()
        print("--------newAddress--------")
        fetchData()
        
    }
    
    
    func fetchData(){
        let building = Int(buildingNoTF.text!)!
        let zipInt = Int(zipTF.text!)
        let addition = Int(additionalNoTF.text!)
        
        
        // if current user equal Users/current display name, mobile and addresses
        db.collection("Users").document((Auth.auth().currentUser?.email!)!).getDocument { [self] doc, err in
            if (err == nil){
                if doc?.exists != false{
                    
                    self.user = try! doc?.data(as: User.self)
                    
                    if self.user?.addressesRef?.count != 0{
                        
                        // loop addresses from user Struct then store it in address model
                        if let addressesRef = self.user?.addressesRef{
                            
                            for addressID in addressesRef {
                                
                                addressID.getDocument { [self] addressDoc, err in
                                    do {
                                        
                                        if (err == nil){
                                            let address = try! addressDoc?.data(as: Address.self)!
                                            print("new Address: \(address)")
                                            let (zip, additionalNo, buildingNo) = (String((address?.zip)!), String((address?.additionalNo)!), String(address!.buildingNo))
                                            if zip != zipTF.text! && additionalNo != additionalNoTF.text! && buildingNo != buildingNoTF.text! && address?.street != streetTF.text! && address?.district != districtTF.text!{
                                                
                                                //                                            self.newAddress = address
                                                self.newAddress = Address(type: addressType.text!, street: streetTF.text!, buildingNo: building, zip: zipInt, additionalNo: addition!, district: districtTF.text!)
                                                
                                                
                                                //                                                print("new Address: \(newAddress)")
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }else {
                        
                        self.newAddress = Address(type: addressType.text!, street: streetTF.text!, buildingNo: building, zip: zipInt, additionalNo: addition!, district: districtTF.text!)
                        print(self.newAddress)
                    }
                }
                
            }
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let proVC = segue.destination as? ProfileVC {
            DispatchQueue.main.async {
                
                proVC.addresses.append(self.newAddress!)
            }
        }
    }
    
    
}



