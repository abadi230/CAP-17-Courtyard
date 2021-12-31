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

class Client {
    var user: User?
    var addresses : [Address]? = []
}

class User: Codable {
//    var delgate : Addresses!
//    @DocumentID var id : String? = "userId\(UUID().uuidString)"
    var name: String?
    var mobile: Int?
    var addressesRef : [DocumentReference]?
    

//    var orders : [DocumentReference]? // string then use it as ref

    
    func storeUserDataInDB(name: String?, mobile: String?, addresses: [Address]?) -> DocumentReference?{
        let dbStore = Firestore.firestore()
        let user = User()
        var addressesRef: [DocumentReference] = []
        if let addresses = addresses {
            
            for address in addresses {
                let ref = (try? dbStore.collection("Addresses").addDocument(from: address))!
                addressesRef.append(ref)
                print("address ref: \(ref)")
            }
        }
        
        user.name = name
        user.mobile = Int(mobile!)
        user.addressesRef = addressesRef
        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: user)
        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
        return userRef
    }
//    func fetchData()-> (User, [Address]){
//        
//    }
    func getData() -> (User){
        let dbStore = Firestore.firestore()
//        let proVC = ProfileVC()
        
        var user = User()
//        var addresses = [Address]()
        var userAddreses : [Address] = []
        
        dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).getDocument { doc, err in
            if (err == nil){
                if doc?.exists != false{
                    
//                    user = try! doc?.data(as: User.self)
                    user = try! doc?.data(as: User.self) ?? User()
//                    self.name = user?.name
//                    self.mobile = user?.mobile
                    
                    // loop addresses from user Struct then store it in address model
                    if let addressesRef = self.addressesRef{
                        
                        for addressID in addressesRef {
                            print("--------addressId------------")
                            print(addressID.documentID)
                            let address = self.getAddresses(addressRef: addressID)
                            userAddreses.append(address)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        print("Complete user address loop")
        return (user)
    }
    
    func getAddresses(addressRef: DocumentReference?) -> Address{
        
        var userAddress : Address!
        if let addressRef = addressRef {
            addressRef.getDocument { addressDoc, err in
                do {
                    if (err == nil){
                        let address = try! addressDoc?.data(as: Address.self)
                        
                        userAddress = address!
                    }
                    
                }
            }
        }
        return userAddress
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
//    var id : String = "addressID\(UUID().uuidString)"
//    let PrimeLocation : Bool
    var type: String 
    var street: String
    var buildingNo : Int
    var zip: Int?
    var additionalNo: Int?
    var district: String?
//    var location: [Double: Double]? = nil
}
struct Service: Codable {
//    var id : String = "sericeID\(UUID().uuidString)"
    var name: String
    var date: Date
    var price: Double
}

struct CodeTest : Codable {
    var name: String?
    var age: Int?
    var orders: [Order]
}
