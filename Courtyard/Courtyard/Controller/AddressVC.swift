//
//  AddressVC.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 18/12/2021.
//

import UIKit
import FirebaseFirestore

class AddressVC: UIViewController, UITableViewDelegate {
    var ref : DocumentReference? = nil
    var users = [User]()
    var addresses = [Address]()
    
    @IBOutlet weak var addressTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressTV.delegate = self
        addressTV.dataSource = self
        fetchData()
    }
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
                print("-----------------queryDocumnetSnapshot------------------------")
                print(queryDocumentSnapshot)
                return try? queryDocumentSnapshot.data(as: Address.self)
            })
            DispatchQueue.main.async {
                
                print("-------User Adresses------------")
                print(self.addresses)
            }
        })
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

extension AddressVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
        cell.addressTypeLbl.text = "Building"
        cell.addressLbl.text = "users[0]"
//        print(users)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

class AddressCell : UITableViewCell{
    @IBOutlet weak var addressTypeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
}
