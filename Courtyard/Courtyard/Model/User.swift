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

class Admin {
    let db = Firestore.firestore()
    var name: String = ""
    var email: String = ""
    var mobile: String = ""
    
    func getAllOrders(complation: @escaping([Order]) -> Void){
        
        var orders = [Order]()
        
        self.db.collection("Orders").getDocuments { snapshot, err in
            if err == nil{
                for doc in snapshot!.documents{
                    do {
                        let order = try doc.data(as: Order.self)
                        orders.append(order!)
                    }catch{
                        print(err?.localizedDescription ?? "Unable to get Data")
                    }
                    complation(orders)
                }
            }
        }
        
    }
    
    func getUserDetail(userId: DocumentReference, complation: @escaping(User) -> Void){
        
    }
    func getUserService(serviceId: DocumentReference, coplation: @escaping(Service)->Void){
        
    }
}
class User: Codable {

    var name: String?
    var mobile: Int?
    var addressesRef : [DocumentReference]?
    

    func addAddressToDB(address: Address?){
        
        let dbStore = Firestore.firestore()
        
        if let address = address {
            // Create Address
            let addressRef = try! dbStore.collection("Addresses").addDocument(from: address)
            
            // Update addressesRef in DB
            let userRef = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
            userRef.updateData(["addressesRef" : FieldValue.arrayUnion([addressRef]) ])
            
        }
    }
    func storeUserDataInDB(name: String?, mobile: String?){
        let dbStore = Firestore.firestore()
        
        self.name = name
        self.mobile = Int(mobile!)
        
        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: self)
        
//        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
//        return userRef
    }
    func userReference()->DocumentReference{
        let db = Firestore.firestore()
        return db.collection("Users").document((Auth.auth().currentUser?.email)!)
    }
    
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
    
    func getOrders(complation: @escaping( ([Order]) -> Void) ){
        let db = Firestore.firestore()
        var orders = [Order]()
        
        db.collection("Orders").getDocuments { snapshot, err in
            if err == nil{
//                snapshot!.documents.compactMap{ doc in
//                    do {
//                        let order = try doc.data(as: Order.self)
//                        orders.append(order!)
//                    }catch{
//                        print(err?.localizedDescription ?? "Unable to get Data")
//                    }
//                }
                for doc in snapshot!.documents{
                    do {
                        let order = try doc.data(as: Order.self)
                        orders.append(order!)
                    }catch{
                        print(err?.localizedDescription ?? "Unable to get Data")
                    }
                    complation(orders)
                }
            }
        }
    }
    // TODO: get user info from userId
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

