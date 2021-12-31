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

// tried to use delegate to pass data
protocol UserData{
    func getData(user: User, addresses: [Address])
}

class Client { // try to get data from DB and control viewcontrollers from here
    var user: User?
    var addresses : [Address]? = []
    var delegate: UserData!
    
    func getData(){
        let dbStore = Firestore.firestore()

        
        var user = User()
        var userAddreses : [Address] = []
        dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).getDocument { doc, err in
            if (err == nil){
                if doc?.exists != false{
                    
//                    user = try! doc?.data(as: User.self)
                    user = try! doc?.data(as: User.self) ?? User()
//                    self.user?.name = user.name
//                    self.user?.mobile = user.mobile
//                    self.user?.addressesRef = user.addressesRef
                    
                    // loop addresses reference from user class then send the references to getAddresses Function
                    if let addressesRef = self.user?.addressesRef{
                        
                        for addressID in addressesRef {
                            print("--------addressId------------")
                            print(addressID.documentID)
                            let address = self.getAddresses(addressRef: addressID)
                            userAddreses.append(address)
                            self.delegate.getData(user: user, addresses: userAddreses)
                            // find way to send address to viewControllers
//                            let data = userAddreses
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        print("Complete user address loop")
//        return (user)
    }

    func getAddresses(addressRef: DocumentReference?) -> Address{
        
        var userAddress : Address!
        if let addressRef = addressRef {
            // fetch addresses then store it in userAddress
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
//class DataModel { // try to use notification
//    static var shareInstance = DataModel()
//
//    private init() {
//
//    }
//
//    private (set) var data: String
//
//    func requestData() {
//        self.data
//    }
//}
class User: Codable {
//    var delgate : Addresses!
//    @DocumentID var id : String? = "userId\(UUID().uuidString)"
    var name: String?
    var mobile: Int?
    var addressesRef : [DocumentReference]?
    

//    var orders : [DocumentReference]? // string then use it as ref

    func storeUserDataInDB(name: String?, mobile: String?, addresses: Address?) -> DocumentReference?{
        let dbStore = Firestore.firestore()
        let user = User()
        var addressesRef: [DocumentReference] = []
        if let addresses = addresses {

            
                let ref = (try? dbStore.collection("Addresses").addDocument(from: addresses))!
                addressesRef.append(ref)
                print("address ref: \(ref)")
        }
        
        user.name = name
        user.mobile = Int(mobile!)
        user.addressesRef = addressesRef
        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: user)
        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
        return userRef
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
//        user.name = name
//        user.mobile = Int(mobile!)
//        user.addressesRef = addressesRef
//        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: user)
//        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
//        return userRef
//    }
    
//    func fetchUserData(userId: String)-> ([String : Any]?){ // tried to send user data as dictionery
//        let dbStore = Firestore.firestore()
//        var user : [String : Any]?
//
//        dbStore.collection("Users").document(userId).getDocument { doc, err in
//            if (err == nil){
//                if let data = try! doc?.data(){
//                    user = data
//                }
//
//            }
//        }
//        return user!
//    }

    
    func getData(){
        let dbStore = Firestore.firestore()
//        let proVC = ProfileVC()
        
        var user = User()
        var userAddreses : [Address] = []
        dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).getDocument { doc, err in
            if (err == nil){
                if doc?.exists != false{
                    
//                    user = try! doc?.data(as: User.self)
                    user = try! doc?.data(as: User.self) ?? User()
                    self.name = user.name
                    self.mobile = user.mobile
                    self.addressesRef = user.addressesRef
                    // loop addresses reference from user class then send the references to getAddresses Function
                    if let addressesRef = self.addressesRef{
                        
                        for addressID in addressesRef {
                            print("--------addressId------------")
                            print(addressID.documentID)
                            let address = self.getAddresses(addressRef: addressID)
                            userAddreses.append(address)
                            
                            // find way to send address to viewControllers
//                            let data = userAddreses
                            
                        }
                        // MARK: I tried to use callback to retrieve data in profileVC
//        dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).getDocument { doc, err in
//            if (err == nil){
//                if doc?.exists != false{
//
////                    user = try! doc?.data(as: User.self)
//                    user = try! doc?.data(as: User.self) ?? User()
////                    self.name = user?.name
////                    self.mobile = user?.mobile
//
//                    // loop addresses reference from user class then send the references to getAddresses Function
//                    if let addressesRef = self.addressesRef{
//
//                        for addressID in addressesRef {
//                            print("--------addressId------------")
//                            print(addressID.documentID)
//                            let address = self.getAddresses(addressRef: addressID)
//                            userAddreses.append(address)
//
//                            // find way to send address to viewControllers
//                            let data = userAddreses
//                            completion(data)
//                        }
                        
                    }
                    
                }
                
            }
            
        }
        print("Complete user address loop")
//        return (user)
    }
    
    func getAddresses(addressRef: DocumentReference?) -> Address{
        
        var userAddress : Address!
        if let addressRef = addressRef {
            // fetch addresses then store it in userAddress
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
    
    func requestData(addresses: [Address], completion: ((_ data: [Address]) -> Void)){
        let data = addresses
         completion(data)
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
