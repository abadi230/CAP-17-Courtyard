//
//  User.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//

import Firebase
//import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit


class User: Codable {
//    var delgate : Addresses!
//    @DocumentID var id : String? = "userId\(UUID().uuidString)"
    var name: String?
    var mobile: Int?
    var addressesRef : [DocumentReference]?
    

    func addAddressToDB(address: Address?){
        
        let dbStore = Firestore.firestore()
        
        if let address = address {
//            let addressID = UUID().uuidString
            
//            self.addressesRef?.append(try! dbStore.collection("Addresses").addDocument(from: address))
//            update addressesRef in DB
            let addressRef = try! dbStore.collection("Addresses").addDocument(from: address)
//            self.addressesRef?.append(addressRef)
            //MARK: THIS CODE DELETE ALL USER INFO IF NOT ADD ADDRESS
//            try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: self)
//            dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(["addressesRef" : addressRef], merge: true)
            let userRef = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
            userRef.updateData(["addressesRef" : FieldValue.arrayUnion([addressRef]) ])
            
        }
    }
    func storeUserDataInDB(name: String?, mobile: String?) -> DocumentReference?{
        let dbStore = Firestore.firestore()
        
        self.name = name
        self.mobile = Int(mobile!)
        
        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: self)
        
        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
        return userRef
    }
    func userReference()->DocumentReference{
        let db = Firestore.firestore()
        return db.collection("Users").document((Auth.auth().currentUser?.email)!)
    }
//    func storeUserDataInDB(name: String?, mobile: String?, addresses: [Address]?) -> DocumentReference?{
//        let dbStore = Firestore.firestore()
//        let user = User()
//        var addressesRef: [DocumentReference] = []
//        if let addresses = addresses {
//
//            for address in addresses {
//                let ref = (try? dbStore.collection("Addresses").addDocument(from: address))!
//                addressesRef.append(ref)
//                print("address ref: \(ref)")
//            }
//        }
//
//
//        user.name = name
//        user.mobile = Int(mobile!)
//        user.addressesRef = addressesRef
//        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: user)
//
//        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
//        return userRef
//    }
    
    func getDataClosure(completion: @escaping (User)->Void) {
        let dbStore = Firestore.firestore()
        
        dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).getDocument { doc, err in
            if (err == nil) {
                do {
                    var user = User()
                    user = try doc?.data(as: User.self) ?? User()
                    self.name = user.name
                    self.mobile = user.mobile
                    self.addressesRef = user.addressesRef

                    print (completion(user))
                    
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }

    func getAddresses(completion: @escaping ([Address])-> Void) {
        var userAddress = [Address]()
        if let addressRef = self.addressesRef {
            for addressID in addressRef {
//                print("--------getAddresses------------")
//
//                print("--------addressId------------")
//                print(addressID.documentID)
//                print("--------number of adderssesRef------------")
//                print(addressRef.count)
                addressID.getDocument { addressDoc, err in
                    do {
                        if (err == nil) {
                            let address = try addressDoc?.data(as: Address.self)
                            userAddress.append(address!)
//                            print("--------number of addersses added------------")
//                            print(userAddress.count)
                        }
                    } catch {
                        print (error.localizedDescription)
                    }
                    completion(userAddress)
                }
            }
        }
    }
}

struct Order: Codable {

    var userId: DocumentReference?
    var serviceId: DocumentReference?
    var date: Date
    var total: Double
    var paymentState: Bool
}

struct Address: Codable {
    var type: String 
    var street: String
    var buildingNo : Int
    var zip: Int?
    var additionalNo: Int?
    var district: String?
}

struct Service: Codable {
    var name: String
    var date: Date
    var price: Double
}

