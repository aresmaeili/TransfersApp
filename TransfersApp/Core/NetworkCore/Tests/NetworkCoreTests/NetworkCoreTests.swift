import XCTest
@testable import NetworkCore

final class NetworkCoreTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testFetchTransfersRealRequest() async throws {
        // Arrange
        var transfers: Transfers = []

        // Act
        do {
            transfers = try await execute()
            print("✅ Transfers fetched successfully!")
        } catch {
            print("❌ Request failed:", error)
        }
        
        // Assert
        XCTAssertFalse(transfers.count != 10, "Expected 10 Transfers after fetch but it is false")

        // Optionally verify some data structure
        print("👤  Transfers count:", transfers.count)
    }
   
   func execute() async throws -> Transfers {
       let endpoint = TransferListEndpoint()
       let result: Transfers = try await NetworkClient.shared.get(urlString: endpoint.fullPath)
       return result
   }

}
