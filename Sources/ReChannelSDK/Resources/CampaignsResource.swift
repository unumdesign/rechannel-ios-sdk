import Foundation

public struct CampaignsResource: Sendable {
    let client: HTTPClient

    /// Create a campaign.
    public func create(_ params: CreateCampaignParams) async throws -> Campaign {
        try await client.post("/v1/campaigns", body: params)
    }

    /// List campaigns with optional filters.
    public func list(
        type: CampaignType? = nil,
        status: CampaignStatus? = nil,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> PaginatedResponse<Campaign> {
        var query = paginationQuery(cursor: cursor, limit: limit)
        if let type { query["type"] = type.rawValue }
        if let status { query["status"] = status.rawValue }
        return try await client.get("/v1/campaigns", query: query)
    }

    /// Get a campaign by ID.
    public func get(id: String) async throws -> Campaign {
        try await client.get("/v1/campaigns/\(id)")
    }

    /// Update a campaign (draft or paused only).
    public func update(id: String, params: UpdateCampaignParams) async throws -> Campaign {
        try await client.patch("/v1/campaigns/\(id)", body: params)
    }

    /// Delete a campaign (draft or archived only).
    public func delete(id: String) async throws {
        try await client.delete("/v1/campaigns/\(id)")
    }

    /// Activate a campaign. Requires policyState ∈ {approved, bypassed}.
    public func activate(id: String) async throws -> Campaign {
        try await client.postReturning("/v1/campaigns/\(id)/activate")
    }

    /// Submit a campaign for policy approval. Returns violations and the new policyState.
    public func submitForApproval(id: String) async throws -> SubmitForApprovalResponse {
        try await client.postReturning("/v1/campaigns/\(id)/submit_for_approval")
    }

    /// Approve a campaign (admin/approver action).
    public func approve(id: String, reason: String? = nil) async throws -> Campaign {
        let body: [String: String] = reason.map { ["reason": $0] } ?? [:]
        return try await client.post("/v1/campaigns/\(id)/approve", body: body)
    }

    /// Reject a campaign (admin/approver action).
    public func reject(id: String, reason: String? = nil) async throws -> Campaign {
        let body: [String: String] = reason.map { ["reason": $0] } ?? [:]
        return try await client.post("/v1/campaigns/\(id)/reject", body: body)
    }

    /// Pause a campaign.
    public func pause(id: String) async throws -> Campaign {
        try await client.postReturning("/v1/campaigns/\(id)/pause")
    }

    /// Archive a campaign.
    public func archive(id: String) async throws -> Campaign {
        try await client.postReturning("/v1/campaigns/\(id)/archive")
    }

    /// List execution history.
    public func listExecutions(id: String, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<CampaignExecution> {
        try await client.get("/v1/campaigns/\(id)/executions", query: paginationQuery(cursor: cursor, limit: limit))
    }
}
