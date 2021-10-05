//
//  ScanningViewModelTests.swift
//  StampsTests
//
//  Created by Inti Albuquerque on 5/10/21.
//

import XCTest
import Combine
@testable import Stamps

class ScanningViewModelTests: XCTestCase {

    var cancellable = Set<AnyCancellable>()
    
    func testMapPublishers() {
        let store = MockReduxStore()
        let api = MockStampsAPI()
        let vm = ScanningViewModel(cardApi: api, reduxStore: store)
        vm.mapPublishers(code: "Store")
            .sink { value in //(code: String?, details: (storeName: String, card: CardData)?, error: ScanningError?) in
                XCTAssertEqual("Store", value.code)
            }
            .store(in: &cancellable)
    }

}

class MockStampsAPI: StampsAPIProtocol {
    var shouldFail = false
    func saveCard(_ card: CardData) -> AnyPublisher<Void, ScanningError> {
        if shouldFail {
            return Fail(error: ScanningError.unableToSave)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: ScanningError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchStoreDetails(code: String) -> AnyPublisher<StoreModel, ScanningError> {
        if shouldFail {
            return Fail(error: ScanningError.unableToScan)
                .eraseToAnyPublisher()
        } else {
            return Just(StoreModel(storeName: "Store", storeId: "id"))
                .setFailureType(to: ScanningError.self)
                .eraseToAnyPublisher()
        }
    }
    
    
}
