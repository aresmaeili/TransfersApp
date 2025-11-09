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
    
    
    struct GetPostEndpoint: Endpoint {
        var host: String { "https://jsonplaceholder.typicode.com" }
        var path: String { "/posts/1" }
        var method: HTTPMethod { .get }
        var queryItems: [URLQueryItem]? { nil }
    }

    struct Post: Decodable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }

    struct CreatePostEndpoint: Endpoint {

        var host: String { "https://jsonplaceholder.typicode.com" }
        var path: String { "/posts" }
        var method: HTTPMethod { .post }

        var body: Data? {
            try? JSONEncoder().encode(
                ["title": "Test Title", "body": "Hello API", "userId": "1"]
            )
        }

        var headers: [String : String]? {
            ["Content-Type": "application/json"]
        }

        var queryItems: [URLQueryItem]? { nil }
    }

    struct CreatedPost: Decodable {
        let id: Int
        let title: String
        let body: String
        let userId: String
    }

}
