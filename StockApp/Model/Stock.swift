//
//  Stock.swift
//  StockApp
//
//  Created by Ruchira  on 27/05/24.
//

import Foundation

struct Stock : Identifiable, Codable {
    let id : String
    var price : Double
    var previousPrice : Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "sid"
        case price
    }
}

struct StockResponse : Codable {
    let success : Bool
    let data : [Stock]
}
