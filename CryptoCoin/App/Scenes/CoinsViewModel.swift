//
//  CoinsViewModel.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 10/01/25.
//

import Foundation
import Combine

enum CoinsViewControllerState {
    case loading
    case loaded
    case error
}

enum ApiEnvironment {
    case apiBRA
    case apiUSA
}

protocol StatefulViewModel {
    associatedtype State
    var statePublisher: AnyPublisher<State, Never> { get }
}

protocol CoinsViewModelProtocol: StatefulViewModel where State == CoinsViewControllerState {
    func searchBar(textDidChange searchText: String)
    func numberOfItemsInSection() -> Int
    func cellForItemAt(indexPath: IndexPath) -> CoinModel
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> CoinModel
    func attempts() -> Int
    func loadDataCoinsUS()
    func loadDataCoinsBR()
    var attempt: Int { get }
    var isRealCoin: Bool { get }
}

class CoinsViewModel: CoinsViewModelProtocol {
    private(set) var attempt = 0
    private(set) var isRealCoin = false
    private var service: ServiceProtocol
    var top10Coins: [CoinModel] = []
    var coinsList: [CoinModel] = []
    var filteredCoinsList: [CoinModel] = []
    
    @Published private var state: CoinsViewControllerState = .loading

     var statePublisher: AnyPublisher<CoinsViewControllerState, Never> {
         $state.eraseToAnyPublisher()
     }
    
    init(serviceProtocol: ServiceProtocol = Service()) {
        self.service = serviceProtocol
    }
    
    func searchBar(textDidChange searchText: String) {
        filteredCoinsList = []
        
        if searchText.isEmpty {
            filteredCoinsList = coinsList
        } else if searchText.hasPrefix("+") {
            filteredCoinsList = coinsList.filter { $0.priceChangePercentage24H > 0 }
        } else if searchText.hasPrefix("-") {
            filteredCoinsList = coinsList.filter { $0.priceChangePercentage24H < 0 }
        } else {
            filteredCoinsList = coinsList.filter { coin in
                coin.name.uppercased().contains(searchText.uppercased()) ||
                coin.symbol.uppercased().contains(searchText.uppercased())
            }
        }
    }
    
    // MARK: CollectionView
    func numberOfItemsInSection() -> Int {
        return top10Coins.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> CoinModel {
        top10Coins[indexPath.item]
    }
    
    // MARK: TableView
    func numberOfRowsInSection() -> Int {
        return filteredCoinsList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> CoinModel {
        filteredCoinsList[indexPath.row]
    }
    
    func attempts() -> Int {
        attempt = state == .error ? attempt + 1 : 0
        return attempt
    }
    
    func loadDataCoinsUS() {
        loadDataCoins(from: ApiEnvironment.apiUSA, isRealCoin: false)
    }
    
    func loadDataCoinsBR() {
        loadDataCoins(from: ApiEnvironment.apiBRA, isRealCoin: true)
    }
    
    func loadDataCoins(from url: ApiEnvironment, isRealCoin: Bool) {
        state = .loading
        
        clearLists()
        self.isRealCoin = isRealCoin
        
        Task { @MainActor in
            do {
                let coins = try await service.getCoins(from: url)
                self.coinsList.append(contentsOf: coins)
                self.filteredCoinsList = self.coinsList
                
                let top10 = self.coinsList.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
                self.top10Coins.append(contentsOf: top10.prefix(10))
                self.coinsList = self.coinsList.sorted { $0.marketCapRank < $1.marketCapRank }
                self.state = .loaded
            } catch {
                print("DEBUG: Erro ao buscar as criptomoedas.. \(error.localizedDescription)")
                self.state = .error
            }
        }
    }
    
    private func clearLists() {
        top10Coins = []
        coinsList = []
    }
}
