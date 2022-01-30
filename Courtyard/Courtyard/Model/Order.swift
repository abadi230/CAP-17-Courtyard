//
//  Order.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 30/01/2022.
//

import Foundation
import FirebaseFirestore

struct Order: Codable {

    var userId: DocumentReference?
    var serviceRef: DocumentReference?
    var addressRef: DocumentReference?
    var date: Date
    var total: Double
    var paymentStatus: Bool
    var status: Bool // change it to string (Accepted, denied and complated)
    
    func getOrders(complation: @escaping( ([Order]) -> Void) ){
        let db = Firestore.firestore()
        var orders = [Order]()
        
        db.collection("Orders").getDocuments { snapshot, err in
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
}
