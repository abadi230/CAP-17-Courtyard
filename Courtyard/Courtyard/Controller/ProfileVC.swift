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
    var addresses: [Address]?
    var db = Firestore.firestore()
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("service: ", service ?? "unable to get data")
    }
    
//    @IBAction func onClickSubmit(_ sender: UIButton) {
//        ref = db.collection("Users").addDocument(data: [
//            "name": nameTF.text!,
//            "mobile": mobileTF.text!,
//            "Address": db.collection("Address").addDocument(data: [
//                "buildingNo": buildingNoTF.text!,
//                "street": streetTF.text!,
//                "district": districtTF.text!,
//                "zip": zipTF.text!,
//                "additionalNo": additionalNoTF.text!
//            ])
//        ]){ err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(self.ref!.documentID)")
//                }
//        }
//    }
    
//    
    
    func fetchUsers(){
        db.collection("Users").addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil  else {
                print("No Documnets")
                return
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
