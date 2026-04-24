import Foundation

public struct AnalyticsResource: Sendable {
    let client: HTTPClient

    /// Get analytics for a campaign.
    public func campaign(id: String) async throws -> CampaignAnalytics {
        try await client.get("/v1/analytics/campaigns/\(id)")
    }

    /// Get analytics for a journey.
    public func journey(id: String) async throws -> JourneyAnalytics {
        try await client.get("/v1/analytics/journeys/\(id)")
    }

    /// Get per-node analytics for a journey.
    public func journeyNodes(id: String) async throws -> [JourneyNodeAnalytics] {
        try await client.get("/v1/analytics/journeys/\(id)/nodes")
    }

    /// Get message history for a user.
    public func user(externalUserId: String) async throws -> UserAnalytics {
        try await client.get("/v1/analytics/users/\(externalUserId.urlEncoded)")
    }
}
