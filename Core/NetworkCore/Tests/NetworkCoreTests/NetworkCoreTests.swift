import XCTest
@testable import NetworkCore


import XCTest

final class NetworkClientRealTests: XCTestCase {

    
    // MARK: - GET Test

    func test_getPost_realAPI() async throws {

        let endpoint = GetPostEndpoint()
        let client = NetworkClient.shared

        do {
            let post: Post = try await client.request(endpoint)

            XCTAssertEqual(post.id, 1)
            print("✅ GET success:", post)
        } catch {
            XCTFail("❌ GET failed: \(error)")
        }
    }

    // MARK: - POST Test

    func test_createPost_realAPI() async throws {

        let endpoint = CreatePostEndpoint()
        let client = NetworkClient.shared

        do {
            let created: CreatedPost = try await client.request(endpoint)

            XCTAssertEqual(created.title, "Test Title")
            XCTAssertEqual(created.body, "Hello API")
            XCTAssertEqual(created.userId, "1")

            print("✅ POST success:", created)
        } catch {
            XCTFail("❌ POST failed: \(error)")
        }
    }
}

extension NetworkCoreTests {
    func execute() async throws -> Transfers {
        let endpoint = TransferListEndpoint(page: 1)
        let result: Transfers = try await NetworkClient.shared.get(endPoint: endpoint)
        return result
    }
     
    public struct TransferListEndpoint: Endpoint {
        public let page: Int
        
        public init(page: Int) {
            self.page = page
        }
        
        public var host: String {  "https://3642fee5-406d-487e-9022-65b1a71665b3.mock.pstmn.io" }
        public var path: String { "/transfer-list" }
        public var method: HTTPMethod { .get }
        public var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
        //    public var options: RequestOptions { .init() }
    }
}
