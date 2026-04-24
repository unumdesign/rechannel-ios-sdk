import Foundation

public struct SegmentsResource: Sendable {
    let client: HTTPClient

    /// Create a segment.
    public func create(_ params: CreateSegmentParams) async throws -> Segment {
        try await client.post("/v1/engage/segments", body: params)
    }

    /// List all segments.
    public func list(cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<Segment> {
        try await client.get("/v1/engage/segments", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Get a segment by ID.
    public func get(id: String) async throws -> Segment {
        try await client.get("/v1/engage/segments/\(id)")
    }

    /// Update a segment.
    public func update(id: String, params: UpdateSegmentParams) async throws -> Segment {
        try await client.patch("/v1/engage/segments/\(id)", body: params)
    }

    /// Delete a segment.
    public func delete(id: String) async throws {
        try await client.delete("/v1/engage/segments/\(id)")
    }

    /// Preview a DSL query without saving.
    public func preview(query: String) async throws -> [UserProfile] {
        try await client.post("/v1/engage/segments/preview", body: ["query": query])
    }

    /// Evaluate a segment and return matching profiles.
    public func evaluate(id: String) async throws -> [UserProfile] {
        try await client.get("/v1/engage/segments/\(id)/evaluate")
    }

    /// Count matching profiles.
    public func count(id: String) async throws -> CountResponse {
        try await client.get("/v1/engage/segments/\(id)/count")
    }

    /// Add a user to a segment.
    public func addMember(id: String, externalUserId: String) async throws {
        try await client.post("/v1/engage/segments/\(id)/members", body: ["externalUserId": externalUserId])
    }

    /// Remove a user from a segment.
    public func removeMember(id: String, externalUserId: String) async throws {
        try await client.delete("/v1/engage/segments/\(id)/members/\(externalUserId.urlEncoded)")
    }

    /// List explicit members of a segment.
    public func listMembers(id: String, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<SegmentMember> {
        try await client.get("/v1/engage/segments/\(id)/members", query: paginationQuery(cursor: cursor, limit: limit))
    }
}
