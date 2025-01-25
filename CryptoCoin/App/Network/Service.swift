//
//  Service.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import Foundation

protocol ServiceProtocol {
    func getCoins(from url: ApiEnvironment, onSuccess: @escaping([CoinModel]) -> Void, onError: @escaping(Error) -> Void)
}

final class Service: ServiceProtocol {
    private var dataTask: URLSessionDataTask?
    
    func getCoins(from url: ApiEnvironment, onSuccess: @escaping([CoinModel]) -> Void, onError: @escaping(Error) -> Void) {
        let apiUrlString: String? = switch url {
        case .apiBRA: Bundle.main.object(forInfoDictionaryKey: "ApiUrlBR") as? String
        case .apiUSA: Bundle.main.object(forInfoDictionaryKey: "ApiUrlUS") as? String
        }
        
        guard let url = URL(string: apiUrlString ?? "") else {
            onError(NSError(domain: "ServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida."]))
            return
        }
        
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
