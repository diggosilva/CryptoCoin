//
//  CoinsViewModelTests.swift
//  CoinsViewModelTests
//
//  Created by Diggo Silva on 13/01/25.
//

import XCTest
import Combine
@testable import CryptoCoin

class MockService: ServiceProtocol {
    var isSuccess: Bool = true
    
    func getCoins(from url: CryptoCoin.ApiEnvironment) async throws -> [CoinModel] {
        if isSuccess {
            return [
                CoinModel(marketCapRank: 1, image: "", name: "DiggoCoin", symbol: "DSC", currentPrice: 0, priceChangePercentage24H: 100),
                CoinModel(marketCapRank: 2, image: "", name: "HelioCoin", symbol: "HMC", currentPrice: 0, priceChangePercentage24H: -10),
            ]
        } else {
            throw NSError(domain: "Error", code: 0)
        }
    }
}

final class CryptoCoinTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testWhenSuccess() async throws {
        let sut: CoinsViewModel = CoinsViewModel(serviceProtocol: MockService())
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataCoinsUS()
        sut.loadDataCoinsBR()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        let attempts = sut.attempts()
        XCTAssertEqual(attempts, 0)
        
        let firstItemTop10 = sut.cellForItemAt(indexPath: IndexPath(row: 0, section: 0))
        let secondItemList = sut.cellForRowAt(indexPath: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(firstItemTop10.name, "DiggoCoin")
        XCTAssertEqual(secondItemList.name, "HelioCoin")
    }
    
    func testSearchBar() async throws {
        let mockService = MockService()
        let sut: CoinsViewModel = CoinsViewModel(serviceProtocol: mockService)
        
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .loaded {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataCoinsUS()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        sut.searchBar(textDidChange: "")
        XCTAssertEqual(sut.filteredCoinsList.count, sut.coinsList.count)
        
        sut.searchBar(textDidChange: "D")
        XCTAssertFalse(sut.filteredCoinsList.isEmpty)
        
        sut.searchBar(textDidChange: "+")
        XCTAssertEqual(sut.filteredCoinsList.first?.priceChangePercentage24H, 100)
        
        sut.searchBar(textDidChange: "-")
        XCTAssertEqual(sut.filteredCoinsList.first?.priceChangePercentage24H, -10)
    }
    
    func testWhenFailure() async throws {
        let mockService = MockService()
        let sut: CoinsViewModel = CoinsViewModel(serviceProtocol: mockService)
        
        mockService.isSuccess = false
        
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        
        sut.statePublisher
            .receive(on: RunLoop.main)
            .sink { state in
                if state == .error {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadDataCoinsUS()
        sut.loadDataCoinsBR()
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        let attempts = sut.attempts()
        XCTAssertEqual(attempts, 1)
    }
}
