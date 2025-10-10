//
//  CoinResponse.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import Foundation

struct CoinResponse: Codable {
    let image, name, symbol: String
    let currentPrice: Double
    let marketCapRank: Int
    let priceChangePercentage24H: Double

    enum CodingKeys: String, CodingKey {
        case image, name, symbol
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}
