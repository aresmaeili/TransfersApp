//
//  SampleReq.swift
//  NetworkCore
//
//  Created by AREM on 11/2/25.
//

//MARK: GET with headers + query items
//struct User: Decodable { let id: Int; let name: String }
//
//let users: [User] = try await NetworkClient.shared.get(
//    endPoint: .users, // your Endpoint
//    headers: ["Authorization": "Bearer \(token)"],
//    queryItems: [
//        URLQueryItem(name: "page", value: "1"),
//        URLQueryItem(name: "limit", value: "20")
//    ],
//    timeout: 30
//)

//MARK: - POST with JSON body
//struct NewPost: Encodable { let title: String; let body: String }
//struct PostResponse: Decodable { let id: Int }
//
//let created: PostResponse = try await NetworkClient.shared.post(
//    endPoint: .createPost,
//    body: NewPost(title: "Hello", body: "World"),
//    headers: ["Authorization": "Bearer \(token)"], // Content-Type added automatically
//    timeout: 30
//)

//MARK: - PUT / PATCH
//struct UpdateUser: Encodable { let name: String }
//
//let updated: User = try await NetworkClient.shared.put(
//    endPoint: .user(id: 123),
//    body: UpdateUser(name: "New Name")
//)
//
//let patched: User = try await NetworkClient.shared.patch(
//    endPoint: .user(id: 123),
//    body: UpdateUser(name: "Another Name")
//)

//MARK: - DELETE that returns a model or an envelope
//struct DeleteResult: Decodable { let success: Bool }
//
//let result: DeleteResult = try await NetworkClient.shared.delete(
//    endPoint: .user(id: 123),
//    headers: ["Authorization": "Bearer \(token)"]
//)

//MARK: - Raw request if you don’t want decoding
//let (data, response) = try await NetworkClient.shared.requestRaw(
//    endPoint: .avatar(id: 123),
//    method: .GET,
//    options: .init(timeout: 15)
//)

//MARK: - Sample Endpoints
//public struct TransferListEndpoint: Endpoint {
//    public let page: Int
//
//    public init(page: Int) {
//        self.page = page
//    }
//
//    public var host: String {
//        "https://2f2e3046-0d87-4cb0-a44e-11eec03cf0fd.mock.pstmn.io"
//    }
//
//    public var path: String { "/transfer-list" }
//
//    public var method: HTTPMethod { .get }
//
//    public var queryItems: [URLQueryItem]? {
//        [URLQueryItem(name: "page", value: "\(page)")]
//    }
//
//    // Optional headers if needed
//    public var headers: [String: String]? {
//        ["Accept": "application/json"]
//    }
//
//    public var body: Data? { nil }
//}
//
//public struct CreateTransferEndpoint: Endpoint {
//    public let model: NewTransferModel
//
//    public init(model: NewTransferModel) {
//        self.model = model
//    }
//
//    public var host: String {
//        "https://2f2e3046-0d87-4cb0-a44e-11eec03cf0fd.mock.pstmn.io"
//    }
//
//    public var path: String { "/transfer" }
//    public var method: HTTPMethod { .POST }
//
//    public var queryItems: [URLQueryItem]? { nil }
//
//    public var headers: [String: String]? {
//        ["Content-Type": "application/json"]
//    }
//
//    public var body: Data? {
//        try? JSONEncoder().encode(model)
//    }
//}
