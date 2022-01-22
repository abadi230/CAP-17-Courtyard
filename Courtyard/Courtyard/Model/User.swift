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
    
    static let shared = Admin()
    
    func getAllOrders(serviceName: String?, complation: @escaping([Order]) -> Void){
        
        var orders = [Order]()
        var servicesRef : [DocumentReference] = []
        var arr = [String]()
        self.db.collection("Orders").getDocuments { snapshot, err in
            if err == nil{
                for doc in snapshot!.documents{
                    do {
                
                        let order = try doc.data(as: Order.self)
                        if serviceName == nil {
                            orders.append(order!)
                        } else{
                            // TODO: try fetch service here
                            /*
                             1. iterate services
                             2. check service name
                             3. if equal to param append reference to array
                             4. outer iteration (Order) check the reference array with orders.serveceRef
                             5. if match append it to orders[]
                             6. send orders with complation
                             */
                            let serviceId = order?.serviceId?.documentID
                            let serviceQuery = self.db.collection("Service").document(serviceId!).parent
//                                .whereField("name", isEqualTo: serviceName!)
                                .whereField("name", isEqualTo: serviceName!)
                            serviceQuery.getDocuments() { snap, error in
                                orders.removeAll()
                                for doc in snap!.documents{
                                    
                                    let docRef = doc.reference
                                    
//                                    print(doc.reference)
//                                    print(doc.data())
                                    
                                    if doc.reference == order?.serviceId{
                                        orders.append(order!)
//                                        print(doc.reference)
//                                        print(doc.data())
                                        print(orders)
                                    }
                                    servicesRef.append(docRef)
                                }
                                
                            }
//                            print("servicequery",serviceRef)
                            
//                            servicesRef.append(order!.serviceId!)
//                            self.getUserService(serviceRef: (order!.serviceId)!) { service in
//                                if service.name == serviceName!{
////                                    print(service.name)
////                                    print(serviceName!)
//                                    arr.append(service.name)
//                                    orders.append(order!)
////                                    print("orders",orders.count)
//                                }
//                            }
                            
                        }
                    }catch{
                        print(err?.localizedDescription ?? "Unable to get Data")
                    }
                    
                    complation(orders)
                }
//                print(arr.count)
                print("servecesRef: \(servicesRef)")
            }
        }
        
    }
    func sortedOrders(){
        
    }
//    func getAllOrders(complation: @escaping([Order]) -> Void){
//
//        var orders = [Order]()
//
//        self.db.collection("Orders").getDocuments { snapshot, err in
//            if err == nil{
//                for doc in snapshot!.documents{
//                    do {
//                        let order = try doc.data(as: Order.self)
//                        orders.append(order!)
//                    }catch{
//                        print(err?.localizedDescription ?? "Unable to get Data")
//                    }
//                    complation(orders)
//                }
//            }
//        }
//
//    }
    func getUserDetail(userRef: DocumentReference?, complation: @escaping(User) -> Void){
        db.collection("Users").document(userRef!.documentID).getDocument { doc, err in
            if err == nil{
                var userInfo : User?
                do {
                    userInfo = try doc?.data(as: User.self)
                    
                }catch{
                    print(err?.localizedDescription ?? "Unable to get Data")
                }
                
                complation(userInfo!)
            }
        }
        
    }
    
    func getUserService(serviceRef: DocumentReference, complation: @escaping(Service)->Void){
        db.collection("Service").document(serviceRef.documentID)
            .getDocument { doc, err in
            if err == nil{
                var service : Service?
                do{
                    service = try doc?.data(as: Service.self)
                }catch{
                    print(err?.localizedDescription ?? "Unable to get Data")
                }
                complation(service!)
            }
        }
    }
}
class User: Codable {

    var name: String?
    var mobile: Int?
    var addressesRef : [DocumentReference]?
    

    // MARK: SETTER
    func addAddressToDB(address: Address?){
        
        let dbStore = Firestore.firestore()
        
        if let address = address {
            // Create Address
            let addressRef = try! dbStore.collection("Addresses").addDocument(from: address)
            changePrimeAddress(for: addressRef)
            // Update addressesRef in DB
            let userRef = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
            userRef.updateData(["addressesRef" : FieldValue.arrayUnion([addressRef]) ])
            
        }
        // MARK: to call this function use this code
        
        //        Admin.getAllOrders(complation: { orders in
        //            print("----------orders count----------------")
        //            print(orders.count)
        //            print("----------orders----------------")
        //            print(orders)
        //        })
    }
    func changePrimeAddress(for addressRer: DocumentReference){
//        let dbStore = Firestore.firestore()
        // get all user addresses
        // updata isPrime to false
        if let userAddresses = self.addressesRef{
             userAddresses.forEach { docRef in
                docRef.setData(["isPrime" : false], merge: true)
            }
        }
//        let primeAddress = dbStore.collection("Addresses").document(addressRer)
        addressRer.setData(["isPrime" : true], merge: true)
    }
    func storeUserDataInDB(name: String?, mobile: String?){
        let dbStore = Firestore.firestore()
        
        self.name = name
        self.mobile = Int(mobile!)
        
        try? dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!).setData(from: self)
        
        
//        let userRef : DocumentReference? = dbStore.collection("Users").document((Auth.auth().currentUser?.email!)!)
//        return userRef
    }
    
    func setOrder(service: Service, servicePrice: Double) -> (DocumentReference, Order){
        let db = Firestore.firestore()
        
        let serviceRef = try? db.collection("Service").addDocument(from: service)
        let total = servicePrice + 0.15 // 15% tax
        
        // create Order
        let order = Order(userId: self.userReference(), serviceId: serviceRef, date: Date(), total: total, paymentState: false)

         //store Orders in DB and return the reference and order
        return try! (db.collection("Orders").addDocument(from: order), order)
    }
    func setService(name: String, date: Date)->Service{
        var priceD : Double

        switch name {
        case "Courtyard":
            priceD = 100
        case "Roof of House":
            priceD = 80
        case "Stairs":
            priceD = 50
        default:
            priceD = 100
        }
        return Service(name: name, date: date, price: priceD)
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

    func getAddresses(completion: @escaping ([Address],[DocumentReference])-> Void) {
        var userAddress = [Address]()
        var references : [DocumentReference] = []
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
                            references.append(addressDoc!.reference)
                        }
                    } catch {
                        print (error.localizedDescription)
                    }
                    completion(userAddress, references)
                }
            }
        }
        
    }
    func getUserOrders(userId: String, complation: @escaping ([Order]) -> Void){
        let db = Firestore.firestore()
        
        db.collection("Orders").getDocuments { snapshot, err in
            if err == nil{
                var userOrders = [Order]()
                
                for doc in snapshot!.documents{
                    do {
                        let order = try doc.data(as: Order.self)
                        // filter order
                        let userDocID = order?.userId?.documentID
                        if userDocID == userId{
                            userOrders.append(order!)
                        }
                    }catch{
                        print(err?.localizedDescription ?? "Unable to get Data")
                    }
                    
                }
                complation((userOrders))
            }
        }
    }
//    // MARK: To Call this in view controller copy the folowing code and paste it in VC
//    // test user Orders
//    let userId = self.user.userReference().documentID
//    user.getUserOrders(userId: userId) { userOrders in
//        print("---------order from comlation---------")
//        print(userOrders.count)
//        print(userOrders)
////            self.orders = userOrders
//
//    }
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
    var isPrime: Bool
}

struct Service: Codable {
    var name: String
    var date: Date
    var price: Double
}

