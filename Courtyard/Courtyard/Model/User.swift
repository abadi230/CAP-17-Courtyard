//
//  User.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
//    @DocumentID var id : String? = "userId\(UUID().uuidString)"
    var name: String?
    var mobile: Int?
    var addresses : [DocumentReference]?
    var orders : [DocumentReference]? // string then use it as ref
    
//    func getAddresses(){
//        
//    }
}

struct Order: Codable {
//    var id : String = "orderID\(UUID().uuidString)"
//    var userId: DocumentReference
    var serviceId: DocumentReference?
    var date: Date
    var total: Double
    
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
