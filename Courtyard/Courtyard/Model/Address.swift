//
//  Address.swift
//  Courtyard
//
//  Created by Abdullah Bajaman on 30/01/2022.
//

import Foundation

struct Address: Codable {
    var type: String
    var street: String
    var buildingNo : Int
    var zip: Int?
    var additionalNo: Int?
    var district: String?
    var isPrime: Bool
}
