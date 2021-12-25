//
//  User.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//

import Foundation
import FirebaseFirestoreSwift

class User: Codable {
    @DocumentID var id : String? = "userId\(UUID().uuidString)"
    var name: String?
    var mobile: Int?
    var addresses : [Address]?
    var orders : [Order]?
//    var services: Service
    
}
struct Address: Codable {
//    let PrimeLocation : Bool
    var street: String
    var buildingNo : Int
    var zip: Int?
    var additionalNo: Int?
    var district: String?
//    var location: [Double: Double]? = nil
}
struct Service: Codable {
    var name: String
    var date: Date
    var price: Double
}

struct Order: Codable {
    var userId: String
    var serviceId: String
    var date: Date
    var total: Double
    
}

struct CodeTest : Codable {
    var name: String?
    var age: Int?
    var orders: [Order]
}
