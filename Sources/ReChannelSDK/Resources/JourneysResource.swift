import Foundation

public struct JourneysResource: Sendable {
    let client: HTTPClient

    /// Create a journey.
    public func create(_ params: CreateJourneyParams) async throws -> Journey {
        try await client.post("/v1/journeys", body: params)
    }

    /// List journeys with optional status filter.
    public func list(status: JourneyStatus? = nil, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<Journey> {
        var query = paginationQuery(cursor: cursor, limit: limit)
        if let status { query["status"] = status.rawValue }
        return try await client.get("/v1/journeys", query: query)
    }

    /// Get a journey by ID.
    public func get(id: String) async throws -> Journey {
        try await client.get("/v1/journeys/\(id)")
    }

    /// Update a journey (draft or paused only).
    public func update(id: String, params: UpdateJourneyParams) async throws -> Journey {
        try await client.patch("/v1/journeys/\(id)", body: params)
    }

    /// Delete a journey (draft or archived only).
    public func delete(id: String) async throws {
        try await client.delete("/v1/journeys/\(id)")
    }

    /// Activate a journey. Requires policyState ∈ {approved, bypassed}.
    public func activate(id: String) async throws -> Journey {
        try await client.postReturning("/v1/journeys/\(id)/activate")
    }

    /// Submit a journey for policy approval. Returns violations and the new policyState.
    public func submitForApproval(id: String) async throws -> SubmitForApprovalResponse {
        try await client.postReturning("/v1/journeys/\(id)/submit_for_approval")
    }

    /// Approve a journey (admin/approver action).
    public func approve(id: String, reason: String? = nil) async throws -> Journey {
        let body: [String: String] = reason.map { ["reason": $0] } ?? [:]
        return try await client.post("/v1/journeys/\(id)/approve", body: body)
    }

    /// Reject a journey (admin/approver action).
    public func reject(id: String, reason: String? = nil) async throws -> Journey {
        let body: [String: String] = reason.map { ["reason": $0] } ?? [:]
        return try await client.post("/v1/journeys/\(id)/reject", body: body)
    }

    /// Pause a journey.
    public func pause(id: String) async throws -> Journey {
        try await client.postReturning("/v1/journeys/\(id)/pause")
    }

    /// Archive a journey.
    public func archive(id: String) async throws -> Journey {
        try await client.postReturning("/v1/journeys/\(id)/archive")
    }

    /// Enroll a user in a journey.
    public func enroll(id: String, externalUserId: String) async throws -> JourneyEnrollment {
        try await client.post("/v1/journeys/\(id)/enroll", body: ["externalUserId": externalUserId])
    }

    /// List enrollments for a journey.
    public func listEnrollments(id: String, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<JourneyEnrollment> {
        try await client.get("/v1/journeys/\(id)/enrollments", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Get a specific enrollment.
    public func getEnrollment(id: String, enrollmentId: String) async throws -> JourneyEnrollment {
        try await client.get("/v1/journeys/\(id)/enrollments/\(enrollmentId)")
    }
}
