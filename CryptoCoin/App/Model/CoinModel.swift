//
//  CoinModel.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 11/01/25.
//

import Foundation

class CoinModel: Codable, Equatable {
    let marketCapRank: Int
    let image: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let priceChangePercentage24H: Double
    
    init(marketCapRank: Int, image: String, name: String, symbol: String, currentPrice: Double, priceChangePercentage24H: Double) {
        self.marketCapRank = marketCapRank
        self.image = image
        self.name = name
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.priceChangePercentage24H = priceChangePercentage24H
    }
    
    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.marketCapRank == rhs.marketCapRank &&
               lhs.image == rhs.image &&
               lhs.name == rhs.name &&
               lhs.symbol == rhs.symbol &&
               lhs.currentPrice == rhs.currentPrice &&
               lhs.priceChangePercentage24H == rhs.priceChangePercentage24H
    }
}
