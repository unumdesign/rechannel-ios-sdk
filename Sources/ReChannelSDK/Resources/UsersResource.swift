import Foundation

public struct UsersResource: Sendable {
    let client: HTTPClient

    /// Create or update a user profile by externalId.
    public func upsert(_ params: CreateUserProfileParams) async throws -> UserProfile {
        try await client.post("/v1/engage/users", body: params)
    }

    /// Bulk upsert up to 100 user profiles.
    public func bulkUpsert(_ profiles: [CreateUserProfileParams]) async throws -> [UserProfile] {
        try await client.post("/v1/engage/users/bulk", body: ["profiles": profiles])
    }

    /// Get a user profile by externalId.
    public func get(externalId: String) async throws -> UserProfile {
        try await client.get("/v1/engage/users/\(externalId.urlEncoded)")
    }

    /// Update a user profile.
    public func update(externalId: String, params: UpdateUserProfileParams) async throws -> UserProfile {
        try await client.patch("/v1/engage/users/\(externalId.urlEncoded)", body: params)
    }

    /// Delete a user profile.
    public func delete(externalId: String) async throws {
        try await client.delete("/v1/engage/users/\(externalId.urlEncoded)")
    }

    /// List user profiles with cursor pagination.
    public func list(cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<UserProfile> {
        try await client.get("/v1/engage/users", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Register a device token for push notifications.
    public func registerDeviceToken(externalId: String, params: RegisterDeviceTokenParams) async throws {
        try await client.post("/v1/engage/users/\(externalId.urlEncoded)/device-tokens", body: params)
    }

    /// Remove a device token.
    public func removeDeviceToken(externalId: String, token: String) async throws {
        try await client.delete("/v1/engage/users/\(externalId.urlEncoded)/device-tokens/\(token.urlEncoded)")
    }

    /// List events for a user.
    public func listEvents(externalId: String, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<UserEvent> {
        try await client.get("/v1/engage/users/\(externalId.urlEncoded)/events", query: paginationQuery(cursor: cursor, limit: limit))
    }
}
