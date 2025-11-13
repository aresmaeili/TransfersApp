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
        
        public var baseUrl: String {  "https://3642fee5-406d-487e-9022-65b1a71665b3.mock.pstmn.io" }
        public var path: String { "/transfer-list" }
        public var method: HTTPMethod { .get }
        public var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
        //    public var options: RequestOptions { .init() }
    }
}
