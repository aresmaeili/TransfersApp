import XCTest
@testable import NetworkCore


import XCTest

final class NetworkClientRealTests: XCTestCase {

    
    // MARK: - GET Test
    func test_getPost_realAPI() async throws {

        do {
            let transfers: [Transfer] = try await execute()

            XCTAssertEqual(transfers.count, 10)
            XCTAssertEqual(transfers.first?.person?.fullName, "Jemimah Sprott")

            print("✅ GET success:", transfers)
        } catch {
            XCTFail("❌ GET failed: \(error)")
        }
    }

    func execute() async throws -> [Transfer] {
        let endpoint = TransferListEndpoint(page: 1)
        let result: [Transfer] = try await NetworkClient.shared.request(endpoint)
        return result
    }
     
    struct TransferListEndpoint: Endpoint {
        
        public let page: Int
        
        public init(page: Int) {
            self.page = page
        }
        
        public var baseUrl: String {  "https://e4253fd8-faab-456a-9f09-a2703d842875.mock.pstmn.io" }
        public var path: String { "/transfer-list" }
        public var method: HTTPMethod { .get }
        public var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
        //    public var options: RequestOptions { .init() }
    }
}
