//
//  Trade.swift
//  StockBar
//
//  Created by Hongliang Fan on 2020-08-01.
//  Copyright © 2020 Hongliang Fan. All rights reserved.
//

import Foundation

struct Trade : Codable, Equatable {
    var name : String
    var position : Position
//    let tickerPublisher = URLSession.shared.dataTaskPublisher(for: url)
//                            .map(\.data)
//                            .decode(
//                                type: Overview.self,
//                                decoder: JSONDecoder()
//                            )
//                            .receive(on: DispatchQueue.main)
}

struct Position : Codable, Equatable {
    var unitSize : String
    var positionAvgCost : String
}

struct TradingInfo {
    var currentPrice : Double = .nan
    var prevClosePrice : Double = .nan
}
