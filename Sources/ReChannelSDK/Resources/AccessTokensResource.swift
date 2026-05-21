import Foundation

public struct AccessTokensResource: Sendable {
    let client: HTTPClient

    /// Create a personal access token. The plaintext `token` is returned ONCE — store it immediately.
    public func create(_ params: CreateAccessTokenParams) async throws -> CreatedAccessToken {
        try await client.post("/v1/access-tokens", body: params)
    }

    /// List your personal access tokens. Plaintext is never returned.
    public func list() async throws -> AccessTokenListResponse {
        try await client.get("/v1/access-tokens")
    }

    /// Revoke a personal access token. Idempotent.
    public func revoke(id: String) async throws {
        try await client.delete("/v1/access-tokens/\(id)")
    }
}
