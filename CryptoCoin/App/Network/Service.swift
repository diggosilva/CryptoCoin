//
//  Service.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 08/01/25.
//

import Foundation

protocol ServiceProtocol {
    func getCoins(onSuccess: @escaping([CoinResponse]) -> Void, onError: @escaping(Error) -> Void)
    func getCoinsBR(onSuccess: @escaping ([CoinResponse]) -> Void, onError: @escaping (any Error) -> Void)
}

final class Service: ServiceProtocol {
    private var dataTask: URLSessionDataTask?
    
    var apiUrl = APIClient.getURL()
    
    func getCoins(onSuccess: @escaping ([CoinResponse]) -> Void, onError: @escaping (any Error) -> Void) {
        guard let url = URL(string: APIClient.apiUSA) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: StatusCode.. \(response.statusCode)")
                }
                do {
                    let response = try JSONDecoder().decode([CoinResponse].self, from: data ?? Data())
                    onSuccess(response)
                } catch {
                    onError(error)
                    print("DEBUG: Erro ao decodificar CoinResponse.. \(error.localizedDescription)")
                }
            }
        })
        dataTask?.resume()
    }
    
    func getCoinsBR(onSuccess: @escaping ([CoinResponse]) -> Void, onError: @escaping (any Error) -> Void) {
        guard let url = URL(string: APIClient.apiBRA) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    print("DEBUG: StatusCode.. \(response.statusCode)")
                }
                do {
                    let response = try JSONDecoder().decode([CoinResponse].self, from: data ?? Data())
                    onSuccess(response)
                } catch {
                    onError(error)
                    print("DEBUG: Erro ao decodificar CoinResponse.. \(error.localizedDescription)")
                }
            }
        })
        dataTask?.resume()
    }
}
