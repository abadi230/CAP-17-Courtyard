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

    var name: String?
    var mobile: Int?
    var addressesRef : [DocumentReference]?
    

    // MARK: SETTER
    func addAddressToDB(address: Address?, complation: @escaping (DocumentReference)->()){
        
        let dbStore = Firestore.firestore()
         
        if let address = address {
            // Create Address
            let addressRef = try! dbStore.collection("Addresses").addDocument(from: address)
            // Update addressesRef in DB
            let userRef = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
            userRef.updateData(["addressesRef" : FieldValue.arrayUnion([addressRef]) ])
            
            changePrimeAddress(for: addressRef)
            
            complation(addressRef)
        }
    }
    func changePrimeAddress(for addressRef: DocumentReference){
        // get all user addresses
        // updata isPrime to false
        if let userAddresses = self.addressesRef{
             userAddresses.forEach { docRef in
                docRef.setData(["isPrime" : false], merge: true)
            }
        }

        addressRef.setData(["isPrime" : true], merge: true)
        
    }
    func storeUserDataInDB(name: String?, mobile: String?){
        let dbStore = Firestore.firestore()
        
        self.name = name
        self.mobile = Int(mobile!)
        
        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: self)
    }
    
    func setOrder(service: Service, servicePrice: Double, addressRef: DocumentReference) -> (DocumentReference, Order){
        let db = Firestore.firestore()
        
        let newService = Service(name: service.name.LocalizableLanguage(name: "en"), date: service.date, price: service.price)
        print(newService.name)
        let serviceRef = try? db.collection("Service").addDocument(from: newService)
        let total = servicePrice
        
        // create Order
        let order = Order(userId: self.userReference(), serviceRef: serviceRef, addressRef: addressRef, date: Date(), total: total, paymentStatus: false, status: false)

        return try! (db.collection("Orders").addDocument(from: order), order)
    }
    
    func setService(name: String, date: Date)->Service{
        var priceD : Double

        switch name.LocalizableLanguage(name: "en") {
        case "Courtyard Cleaning":
            priceD = 100
        case "Roof of House Cleaning":
            priceD = 80
        case "Stairs Cleaning":
            priceD = 50
        default:
            priceD = 100
        }
        return Service(name: name.LocalizableLanguage(name: "en"), date: date, price: priceD)
    }
    
    // MARK: Getter
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

                    completion(user)
                    
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }

    func getAddresses(completion: @escaping ([Address],[DocumentReference],DocumentReference)-> Void) {
        var userAddress = [Address]()
        var references : [DocumentReference] = []
        var primeRef : DocumentReference?
        guard let addressRef = self.addressesRef else {return}
            for addressID in addressRef {

                addressID.getDocument { addressDoc, err in
                    do {
                        if (err == nil) {
                            guard let address = try addressDoc?.data(as: Address.self) else {return}
                            userAddress.append(address)

                            references.append(addressDoc!.reference)
                            if address.isPrime == true {
                                primeRef = addressDoc!.reference
                            }
                        }
                    } catch {
                        print (error.localizedDescription)
                    }
                    if let primeRef = primeRef {
                        completion(userAddress, references, primeRef)
                    }
                }
            }
    }
    func getPrimeAddress(complation: @escaping  (Address)->()){
        var primeAddress : Address?
        guard let addressesRef = self.addressesRef else { return }
        addressesRef.forEach { document in
            document.getDocument { snapShot, error in
                do {
                    if error == nil {
                        let address = try snapShot?.data(as: Address.self)
                        if (address?.isPrime == true ) { primeAddress = address! }
                    }
                }catch{
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    
                    complation(primeAddress!)
                }
            }
        }
    }
    func getUserOrders(userId: String, complation: @escaping ([Order], [String]) -> Void){
        let db = Firestore.firestore()
        
        db.collection("Orders").getDocuments { snapshot, err in
            if err == nil{
                var userOrders = [Order]()
                var ordersRef : [String] = []
                for doc in snapshot!.documents{
                    do {
                        let order = try doc.data(as: Order.self)
                        // filter order
                        let userDocID = order?.userId?.documentID
                        if userDocID == userId{
                            userOrders.append(order!)
                            ordersRef.append(doc.documentID)
                        }
                        
                    }catch{
                        print(err?.localizedDescription ?? "Unable to get Data")
                    }
                    
                }
                complation(userOrders, ordersRef)
            }
        }
    }

    // MARK: DELETE
    func removeAddress(addressRef: DocumentReference){
        self.addressesRef?.forEach({ address in
            if addressRef == address {
                let userRef = self.userReference()
                userRef.updateData(["addressesRef" : FieldValue.arrayRemove([addressRef])])
                addressRef.delete { err in
                    if let err = err {
                        print(err.localizedDescription)
                    }else{
                        print("Document Successfully removed!")
                    }
                }
            }
        })
    }
    
}
