//
//  Service.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import Foundation

protocol ServiceProtocol {
    func getCoins(from url: String, onSuccess: @escaping ([CoinModel]) -> Void, onError: @escaping (any Error) -> Void)
}

final class Service: ServiceProtocol {
    private var dataTask: URLSessionDataTask?
        
    func getCoins(from url: String, onSuccess: @escaping ([CoinModel]) -> Void, onError: @escaping (any Error) -> Void) {
        guard let url = URL(string: url) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: StatusCode.. \(response.statusCode)")
                }
                do {
                    let coinResponse = try JSONDecoder().decode([CoinResponse].self, from: data ?? Data())
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
                    onSuccess(coinModels)
                } catch {
                    onError(error)
                    print("DEBUG: Erro ao decodificar CoinResponse.. \(error.localizedDescription)")
                }
            }
        })
        dataTask?.resume()
    }
}
