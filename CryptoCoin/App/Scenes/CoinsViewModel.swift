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
    func cellForItemAt(indexPath: IndexPath) -> CoinResponse
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> CoinResponse
    var state: Bindable<CoinsViewControllerState> { get }
    func fetchCoins()
    func fetchCoinsBR()
    func attempts() -> Int
    var attempt: Int { get }
    var isRealCoin: Bool { get }
}

class CoinsViewModel: CoinsViewModelProtocol {
    private(set) var state: Bindable<CoinsViewControllerState> = Bindable(value: .loading)
    private(set) var attempt = 0
    private var service: ServiceProtocol = Service()
    var top10Coins: [CoinResponse] = []
    var coinsList: [CoinResponse] = []
    private(set) var isRealCoin = false
    
    // MARK: CollectionView
    func numberOfItemsInSection() -> Int {
        return top10Coins.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> CoinResponse {
        top10Coins[indexPath.item]
    }
    
    // MARK: TableView
    func numberOfRowsInSection() -> Int {
        return coinsList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> CoinResponse {
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
        top10Coins = []
        coinsList = []
        isRealCoin = false
        service.getCoins { coins in
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
        top10Coins = []
        coinsList = []
        isRealCoin = true
        service.getCoinsBR { coins in
            self.coinsList.append(contentsOf: coins)
            let top10 = self.coinsList.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
            self.top10Coins.append(contentsOf: top10.prefix(10))
            self.state.value = .loaded
        } onError: { error in
            print("DEBUG: Erro ao buscar as criptomoedas.. \(error.localizedDescription)")
            self.state.value = .error
        }
    }
}
