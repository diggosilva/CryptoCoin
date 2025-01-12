//
//  CoinsViewModel.swift
//  CryptoCoin
//
//  Created by Diggo Silva on 10/01/25.
//

import Foundation

enum CoinsViewControllerState {
    case loading
    case loaded
    case error
}

protocol CoinsViewModelProtocol {
    func numberOfItemsInSection() -> Int
    func cellForItemAt(indexPath: IndexPath) -> CoinModel
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> CoinModel
    func fetchCoins()
    func fetchCoinsBR()
    func attempts() -> Int
    var state: Bindable<CoinsViewControllerState> { get }
    var attempt: Int { get }
    var isRealCoin: Bool { get }
}

class CoinsViewModel: CoinsViewModelProtocol {
    private(set) var state: Bindable<CoinsViewControllerState> = Bindable(value: .loading)
    private(set) var attempt = 0
    private var service: ServiceProtocol = Service()
    var top10Coins: [CoinModel] = []
    var coinsList: [CoinModel] = []
    private(set) var isRealCoin = false
    
    // MARK: CollectionView
    func numberOfItemsInSection() -> Int {
        return top10Coins.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> CoinModel {
        top10Coins[indexPath.item]
    }
    
    // MARK: TableView
    func numberOfRowsInSection() -> Int {
        return coinsList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> CoinModel {
        coinsList[indexPath.row]
    }
    
    func attempts() -> Int {
        if state.value == .error {
            attempt += 1
        } else {
            attempt = 0
        }
        return attempt
    }
    
    func fetchCoins() {
        clearLists()
        isRealCoin = false
        service.getCoins(from: APIClient.apiUSA) { coins in
            self.coinsList.append(contentsOf: coins)
            let top10 = self.coinsList.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
            self.top10Coins.append(contentsOf: top10.prefix(10))
            
            self.state.value = .loaded
        } onError: { error in
            print("DEBUG: Erro ao buscar as criptomoedas.. \(error.localizedDescription)")
            self.state.value = .error
        }
    }
    
    func fetchCoinsBR() {
        clearLists()
        isRealCoin = true
        service.getCoins(from: APIClient.apiBRA) { coins in
            self.coinsList.append(contentsOf: coins)
            let top10 = self.coinsList.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
            self.top10Coins.append(contentsOf: top10.prefix(10))
            
            self.state.value = .loaded
        } onError: { error in
            print("DEBUG: Erro ao buscar as criptomoedas.. \(error.localizedDescription)")
            self.state.value = .error
        }
    }
    
    private func clearLists() {
        top10Coins = []
        coinsList = []
    }
}
