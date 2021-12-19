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
    var name: String = ""
    var mobile: Int = 0
    var addresses : [Address]?
    var orders : [Order]?
    
}
struct Address: Codable {
//    let PrimeLocation : Bool
    let street: String
    let buildingNo : Int
    let zip: Int?
    let additionalNo: Int?
//    let location: [Double: Double]? = nil
}
struct Service: Codable {
    let name: String
    let price: Double
}
struct Order: Codable {
    let userId: String
    let serviceId: String
}
