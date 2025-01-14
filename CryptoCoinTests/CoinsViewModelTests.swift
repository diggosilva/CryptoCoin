//
//  CoinsViewModelTests.swift
//  CoinsViewModelTests
//
//  Created by Diggo Silva on 13/01/25.
//

import XCTest
@testable import CryptoCoin

class mockSuccess: ServiceProtocol {
    func getCoins(from url: String, onSuccess: @escaping ([CoinModel]) -> Void, onError: @escaping (Error) -> Void) {
        onSuccess([
            CoinModel(marketCapRank: 1, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 2, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 3, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 4, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 5, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 6, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 7, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 8, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 9, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 10, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 11, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 0),
            CoinModel(marketCapRank: 12, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: 0),
        ])
    }
}

class mockFailure: ServiceProtocol {
    func getCoins(from url: String, onSuccess: @escaping ([CoinModel]) -> Void, onError: @escaping (Error) -> Void) {
        onError(NSError(domain: "Error", code: 0))
    }
}

final class CryptoCoinTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testWhenSuccess() {
        let sut: CoinsViewModel = CoinsViewModel(serviceProtocol: mockSuccess())
        sut.state.bind { state in
            XCTAssertTrue(state == .loaded)
        }
        sut.loadDataCoinsUS()
        sut.loadDataCoinsBR()
        
        let attempts = sut.attempts()
        XCTAssertEqual(attempts, 0)
        
        sut.searchBar(textDidChange: "D")
        XCTAssertTrue(sut.filteredCoinsList != [])
    }
    
    func testWhenFailure() {
        let sut: CoinsViewModel = CoinsViewModel(serviceProtocol: mockFailure())
        sut.state.bind { state in
            XCTAssertTrue(state == .error)
        }
        sut.loadDataCoinsUS()
        sut.loadDataCoinsBR()
        
        let attempts = sut.attempts()
        XCTAssertEqual(attempts, 1)
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
