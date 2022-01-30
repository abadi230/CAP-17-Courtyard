//
//  Admin.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 30/01/2022.
//

import Foundation
import FirebaseFirestore

class Admin {
    let db = Firestore.firestore()
    
    static let shared = Admin()
    
    // MARK: Getter
    func getAllOrders(complation: @escaping([Order], [DocumentReference]) -> Void){

        var orders = [Order]()
        var ordersRef = [DocumentReference]()

        self.db.collection("Orders").getDocuments { snapshot, err in
            if err == nil{
                for doc in snapshot!.documents{
                    do {
                        let order = try doc.data(as: Order.self)
                        orders.append(order!)
                        ordersRef.append(doc.reference)
                        
                    }catch{
                        print(err?.localizedDescription ?? "Unable to get Data")
                    }
                    complation(orders, ordersRef)
                }
            }
        }

    }
    func getUserAddress(addressRef: DocumentReference, complation: @escaping(Address)->()){
        addressRef.getDocument { addressDoc, error in
            if error == nil{
                var address : Address
                do{
                    if let doc = addressDoc{
                        
                        address = try doc.data(as: Address.self)!
                        complation(address)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
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
