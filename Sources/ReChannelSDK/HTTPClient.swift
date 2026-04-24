import Foundation

actor HTTPClient {
    private var baseURL: String
    private var token: String?
    private var apiKey: String?
    private var tenantId: String
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(baseURL: String, token: String?, apiKey: String?, tenantId: String) {
        self.baseURL = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        self.token = token
        self.apiKey = apiKey
        self.tenantId = tenantId
        self.session = URLSession.shared
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }

    func setToken(_ token: String) {
        self.token = token
    }

    func setTenantId(_ tenantId: String) {
        self.tenantId = tenantId
    }

    // MARK: - HTTP Methods

    func get<T: Decodable>(_ path: String, query: [String: String]? = nil) async throws -> T {
        let request = try buildRequest(method: "GET", path: path, query: query)
        return try await execute(request)
    }

    func post<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let request = try buildRequest(method: "POST", path: path, body: body)
        return try await execute(request)
    }

    func post(_ path: String) async throws {
        let request = try buildRequest(method: "POST", path: path)
        try await executeVoid(request)
    }

    func postReturning<T: Decodable>(_ path: String) async throws -> T {
        let request = try buildRequest(method: "POST", path: path)
        return try await execute(request)
    }

    func post<B: Encodable>(_ path: String, body: B) async throws {
        let request = try buildRequest(method: "POST", path: path, body: body)
        try await executeVoid(request)
    }

    func patch<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let request = try buildRequest(method: "PATCH", path: path, body: body)
        return try await execute(request)
    }

    func put<B: Encodable>(_ path: String, body: B) async throws {
        let request = try buildRequest(method: "PUT", path: path, body: body)
        try await executeVoid(request)
    }

    func put<T: Decodable, B: Encodable>(_ path: String, body: B) async throws -> T {
        let request = try buildRequest(method: "PUT", path: path, body: body)
        return try await execute(request)
    }

    func delete(_ path: String) async throws {
        let request = try buildRequest(method: "DELETE", path: path)
        try await executeVoid(request)
    }

    // MARK: - Internal

    private func buildRequest(
        method: String,
        path: String,
        query: [String: String]? = nil
    ) throws -> URLRequest {
        guard var components = URLComponents(string: "\(baseURL)\(path)") else {
            throw ReChannelError.invalidURL("\(baseURL)\(path)")
        }

        if let query, !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw ReChannelError.invalidURL(components.string ?? path)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let apiKey {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }

        request.setValue(tenantId, forHTTPHeaderField: "x-tenant-id")

        return request
    }

    private func buildRequest<B: Encodable>(
        method: String,
        path: String,
        query: [String: String]? = nil,
        body: B
    ) throws -> URLRequest {
        var request = try buildRequest(method: method, path: path, query: query)
        request.httpBody = try encoder.encode(body)
        return request
    }

    private func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await performRequest(request)
        try checkResponse(response, data: data)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ReChannelError.decoding(error)
        }
    }

    private func executeVoid(_ request: URLRequest) async throws {
        let (data, response) = try await performRequest(request)
        try checkResponse(response, data: data)
    }

    private func performRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw ReChannelError.network(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ReChannelError.network(URLError(.badServerResponse))
        }

        return (data, httpResponse)
    }

    private func checkResponse(_ response: HTTPURLResponse, data: Data) throws {
        guard !(200...299).contains(response.statusCode) else { return }

        let body = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let message = (body?["message"] as? String) ?? HTTPURLResponse.localizedString(forStatusCode: response.statusCode)

        switch response.statusCode {
        case 400:
            throw ReChannelError.validation(message, details: body)
        case 401:
            throw ReChannelError.authentication(message)
        case 404:
            throw ReChannelError.notFound(message)
        case 429:
            let retryAfter = response.value(forHTTPHeaderField: "retry-after").flatMap(Int.init)
            throw ReChannelError.rateLimited(retryAfter: retryAfter)
        default:
            throw ReChannelError.api(statusCode: response.statusCode, message: message, details: body)
        }
    }
}
