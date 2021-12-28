//
//  AddressVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 18/12/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddressVC: UIViewController{
    var db = Firestore.firestore()
//    var users = [User]()
    var address : Address?
    
    
    @IBOutlet weak var addressType: UITextField!
    @IBOutlet weak var buildingNoTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var districtTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var additionalNoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        fetchData()
    }
    

    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        // send data to Address
        let building = Int(buildingNoTF.text!)!
        let zip = Int(zipTF.text!)
        let addition = Int(additionalNoTF.text!)

        address = Address(type: addressType.text!, street: streetTF.text!, buildingNo: building, zip: zip!, additionalNo: addition!, district: districtTF.text!)
        
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let proVC = segue.destination as? ProfileVC {
            proVC.addresses.append(address!)
        }
    }
    

}



