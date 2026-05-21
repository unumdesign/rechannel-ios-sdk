import Foundation

public struct AudiencesResource: Sendable {
    let client: HTTPClient

    /// Create an audience.
    public func create(_ params: CreateAudienceParams) async throws -> Audience {
        try await client.post("/v1/audiences", body: params)
    }

    /// List all audiences.
    public func list(cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<Audience> {
        try await client.get("/v1/audiences", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Get an audience by ID.
    public func get(id: String) async throws -> Audience {
        try await client.get("/v1/audiences/\(id)")
    }

    /// Update an audience.
    public func update(id: String, params: UpdateAudienceParams) async throws -> Audience {
        try await client.patch("/v1/audiences/\(id)", body: params)
    }

    /// Delete an audience.
    public func delete(id: String) async throws {
        try await client.delete("/v1/audiences/\(id)")
    }

    /// Preview a DSL query without saving.
    public func preview(query: String) async throws -> [UserProfile] {
        try await client.post("/v1/audiences/preview", body: ["query": query])
    }

    /// Evaluate an audience and return matching profiles.
    public func evaluate(id: String) async throws -> [UserProfile] {
        try await client.get("/v1/audiences/\(id)/evaluate")
    }

    /// Count matching profiles.
    public func count(id: String) async throws -> CountResponse {
        try await client.get("/v1/audiences/\(id)/count")
    }

    /// Add a user to an audience.
    public func addMember(id: String, externalUserId: String) async throws {
        try await client.post("/v1/audiences/\(id)/members", body: ["externalUserId": externalUserId])
    }

    /// Remove a user from an audience.
    public func removeMember(id: String, externalUserId: String) async throws {
        try await client.delete("/v1/audiences/\(id)/members/\(externalUserId.urlEncoded)")
    }

    /// List explicit members of an audience.
    public func listMembers(id: String, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<AudienceMember> {
        try await client.get("/v1/audiences/\(id)/members", query: paginationQuery(cursor: cursor, limit: limit))
    }
}
