//
//  UserData.swift
//  StockBar
//
//  Created by Hongliang Fan on 2020-08-02.
//  Copyright © 2020 Hongliang Fan. All rights reserved.
//

import Foundation
import Combine

class RealTimeTrade : ObservableObject {
    @Published var trade : Trade
    @Published var realTimeInfo : TradingInfo
    init(trade: Trade, realTimeInfo: TradingInfo) {
        self.trade = trade
        self.realTimeInfo = realTimeInfo
        self.cancellable = $trade
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates {
                $0.name == $1.name
            }
            .setFailureType(to: URLSession.DataTaskPublisher.Failure.self)
            .flatMap { singleTrade in
                    //print ("Update")
                    return URLSession.shared.dataTaskPublisher(for: URL( string: ("https://query1.finance.yahoo.com/v8/finance/chart/\(singleTrade.name)?interval=1d") )!)
            }
            .map(\.data)
            .compactMap { try? JSONDecoder().decode(Overview.self, from: $0) }
            .receive(on: RunLoop.main)
            .sink (
                receiveCompletion: { _ in
                    print ("HitCompletion")
                },
                receiveValue: { overview in
                    let chart = overview.chart;
                    if let msg = chart.error {
                        // Error occured
                        print ("\(msg)")
                    }
                    else if let results = chart.result {
                        self.realTimeInfo.currentPrice = results[0].meta.regularMarketPrice
                    }
                }
            )
    }
    var cancellable : AnyCancellable? = nil
    
}

// This is a single source of truth during the running of this app.
// It loads from the UserDefaults at startup and all the user input goes here. It then updates the UserDefaults
class UserData {
    static let sharedInstance = UserData()
    let decoder = JSONDecoder()
    var realTimeTrades : [RealTimeTrade]
    init() {
        let data = UserDefaults.standard.object(forKey: "usertrades") as? Data ?? Data()
        self.realTimeTrades = ((try? decoder.decode([Trade].self, from: data)) ?? emptyTrades(size: 3)).map {
            RealTimeTrade(trade: $0, realTimeInfo: TradingInfo())
        }
    }
}

func emptyTrades(size : Int) -> [Trade]{
    return [Trade].init(repeating: Trade(name: "", position: Position(unitSize: "", positionAvgCost: "")), count: size)
}
