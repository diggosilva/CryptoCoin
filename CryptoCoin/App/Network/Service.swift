//
//  Service.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import Foundation

protocol ServiceProtocol {
    func getCoins(from url: ApiEnvironment) async throws -> [CoinModel]
}

final class Service: ServiceProtocol {
    func getCoins(from url: ApiEnvironment) async throws -> [CoinModel] {
        let apiUrlString: String? = switch url {
        case .apiBRA: Bundle.main.object(forInfoDictionaryKey: "ApiUrlBR") as? String
        case .apiUSA: Bundle.main.object(forInfoDictionaryKey: "ApiUrlUS") as? String
        }
        
        guard let url = URL(string: apiUrlString ?? "") else {
            throw NSError(domain: "ServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida."])
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let response = response as? HTTPURLResponse {
            print("DEBUG: StatusCode.. \(response.statusCode)")
        }
        do {
            let coinResponse = try JSONDecoder().decode([CoinResponse].self, from: data)
            var coinModels: [CoinModel] = []
            
            for coinModel in coinResponse {
                let coin = CoinModel(marketCapRank: coinModel.marketCapRank,
                                     image: coinModel.image,
                                     name: coinModel.name,
                                     symbol: coinModel.symbol,
                                     currentPrice: coinModel.currentPrice,
                                     priceChangePercentage24H: coinModel.priceChangePercentage24H)
                coinModels.append(coin)
            }
            return coinModels
        } catch {
            print("DEBUG: Erro ao decodificar CoinResponse.. \(error.localizedDescription)")
            throw error
        }
    }
}
