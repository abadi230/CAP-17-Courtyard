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
    var users = [User]()
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
    
//
//        print("-----------------------------------------------------------")
//        print(addresses)
//        let proVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileId") as! ProfileVC
//        proVC.addresses += addresses
////        proVC.addressesTV.reloadData()
//        present(proVC, animated: true, completion: nil)
////        self.navigationController?.popViewController(animated: true)
        
        
        
        
        
//        // add Document to sub collection
//        let address = db.collection("Users").document("Abadi").collection("Address")
//        address.addDocument(data: [
//            "buildingNo": buildingNoTF.text!,
//            "street": streetTF.text!,
//            "district": districtTF.text!,
//            "zip": zipTF.text!,
//            "additionalNo": additionalNoTF.text!
//        ])
        
    }
    /*
    func fetchData(){
        let db = Firestore.firestore()
        let users = db.collection("/Users/C4PBPGzsX710rVqtpbg8/Address")
        
//        users.getDocuments(completion: { querySnapshot, err in
//            print(querySnapshot?.documents.count)
//        })
        
        users.addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }

            documents.compactMap({ (queryDocumentSnapshot) -> Address? in
//                self.addresses.append(Address(street: "la;sdkjf", buildingNo: 323, zip: 23434, additionalNo: 33))
                //                self.addresses.append(queryDocumentSnapshot.data())
                print("------------------queryDocumnetSnapshot.data()-----------------------")
                print(queryDocumentSnapshot.data())
                /* Output: ["street": Prince Mohammed Bin Abdulaziz, "district": Bani Harithah, "city": AlMadinah, "country": KSA, "additional_no": 8391, "building_no": 5264, "postal_code": 42313]
*/
                print("-----------------queryDocumnetSnapshot------------------------")
                print(queryDocumentSnapshot)
                print("---------------document Id-------------")
                print(queryDocumentSnapshot.documentID)
                // Output: gqRtO412fGahNw33rhGZ
                
                
                let myData = try? queryDocumentSnapshot.data(as: Address.self)
                print (myData)
                return myData
                
            })
            DispatchQueue.main.async {
                
                print("-------User Adresses------------")
                print(self.addresses)
            }
        })
    }
*/
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let proVC = segue.destination as? ProfileVC {
            proVC.addresses.append(address!)
        }
    }
    

}



