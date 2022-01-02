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
        
        let building = Int(buildingNoTF.text!)!
        let zipInt = Int(zipTF.text!)
        let addition = Int(additionalNoTF.text!)
        
        self.newAddress = Address(type: addressType.text!, street: streetTF.text!, buildingNo: building, zip: zipInt, additionalNo: addition!, district: districtTF.text!)
        user?.addAddressToDB(address: newAddress)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let proVC = segue.destination as? ProfileVC {
                
            proVC.address = self.newAddress!
        }
    }
    
    
}



