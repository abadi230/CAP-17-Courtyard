//
//  User.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 17/12/2021.
//

import Foundation

class User {
//    let id : String = ""
    let name: String = ""
    let mobile: Int = 0
    let address : [Address]? = nil
}
struct Address {
    let PrimeLocation : Bool = true
    let street: String? = nil
    let buildingNo : Int? = nil
    let zip: Int? = nil
    let additionalNo: Int? = nil
    let location: [Double: Double]? = nil
}
struct Service {
    let name: String = ""
    let price: Double = 0
}
struct Order {
    let userId: String = ""
    let serviceId: String = ""
}
