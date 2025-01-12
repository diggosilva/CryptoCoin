//
//  CoinModel.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 11/01/25.
//

import Foundation

class CoinModel: Codable {
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
}
