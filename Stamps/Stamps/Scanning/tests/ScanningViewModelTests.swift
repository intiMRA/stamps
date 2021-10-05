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
                XCTAssertEqual("Store", value.details?.storeName)
            }
            .store(in: &cancellable)
        
        vm.mapPublishers(code: "+-924$")
            .sink { value in //(code: String?, details: (storeName: String, card: CardData)?, error: ScanningError?) in
                XCTAssertEqual("Invalid Code", value.error?.title)
                XCTAssertEqual("The QR code you scanned is not in our database, or a scanning error occurred", value.error?.message)
            }
            .store(in: &cancellable)
        
        api.shouldFailSave = true
        
        vm.mapPublishers(code: "Store")
            .sink { value in //(code: String?, details: (storeName: String, card: CardData)?, error: ScanningError?) in
                XCTAssertEqual(ScanningError.unableToSave.title, value.error?.title)
                XCTAssertEqual(ScanningError.unableToSave.message, value.error?.message)
            }
            .store(in: &cancellable)
        
        api.shouldFailFetch = true
        api.shouldFailSave = false
        
        vm.mapPublishers(code: "Store")
            .sink { value in //(code: String?, details: (storeName: String, card: CardData)?, error: ScanningError?) in
                XCTAssertEqual(ScanningError.unableToScan.title, value.error?.title)
                XCTAssertEqual(ScanningError.unableToScan.message, value.error?.message)
            }
            .store(in: &cancellable)
    }
    
    func testFoundQRCode() {
        let store = MockReduxStore()
        let data = CardData(card: [[CardSlot(isStamped: false, index: "0_0"), CardSlot(isStamped: false, index: "0_1")]], storeName: "Store", storeId: "StoreID", listIndex: 0, nextToStamp: (row: 0, col: 0), numberOfRows: 1, numberOfColums: 1, numberOfStampsBeforeReward: 1)
        
        store.customerModel = CustomerModel(userId: "id", username: "name", stampCards: [data])
        store.storeModel = StoreModel(storeName: "Store", storeId: "StoreID")
        let api = MockStampsAPI()
        let vm = ScanningViewModel(cardApi: api, reduxStore: store)
        
        vm.foundQRCode("$$", details: (storeName: "Store", card: data))
        
        vm.$shouldShowAlert
            .sink { value in
                XCTAssertEqual(vm.error?.title, "Invalid Code")
                XCTAssertEqual(vm.error?.message, "The QR code you scanned is not in our database, or a scanning error occurred")
            }
            .store(in: &cancellable)
        
        vm.foundQRCode("StoreID", details: (storeName: "Store", card: data))
        vm.$storeName
            .sink { value in
                XCTAssertEqual("Store", value)
                XCTAssertEqual(store.customerModel?.stampCards[0].storeId, data.storeId)
            }
            .store(in: &cancellable)
        
        vm.foundQRCode("StoreID", details: (storeName: "Store", card: data))
        vm.$storeName
            .sink { value in
                XCTAssertEqual("Store", value)
                XCTAssertEqual(store.customerModel?.stampCards[0].storeId, data.storeId)
            }
            .store(in: &cancellable)
        
    }

}

class MockStampsAPI: StampsAPIProtocol {
    var shouldFailSave = false
    var shouldFailFetch = false
    func saveCard(_ card: CardData) -> AnyPublisher<Void, ScanningError> {
        if shouldFailSave {
            return Fail(error: ScanningError.unableToSave)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: ScanningError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchStoreDetails(code: String) -> AnyPublisher<StoreModel, ScanningError> {
        if shouldFailFetch {
            return Fail(error: ScanningError.unableToScan)
                .eraseToAnyPublisher()
        } else {
            return Just(StoreModel(storeName: "Store", storeId: "id"))
                .setFailureType(to: ScanningError.self)
                .eraseToAnyPublisher()
        }
    }
    
    
}
