import Foundation

public enum AdCampaignStatus: String, Codable, Sendable {
    case active
    case paused
    case archived
}

public struct AdCampaignsResource: Sendable {
    let client: HTTPClient

    /// Pause / resume / archive a campaign.
    public func setStatus(_ campaignId: String, status: AdCampaignStatus) async throws -> AdCampaign {
        struct Body: Encodable { let status: AdCampaignStatus }
        return try await client.post("/v1/ad-campaigns/\(campaignId)/status", body: Body(status: status))
    }

    /// Edit campaign fields.
    public func update(
        _ campaignId: String,
        name: String? = nil,
        budget: AnyCodable? = nil,
        objective: String? = nil,
        bidStrategy: String? = nil
    ) async throws -> AdCampaign {
        struct Body: Encodable {
            let name: String?
            let budget: AnyCodable?
            let objective: String?
            let bidStrategy: String?
        }
        return try await client.patch(
            "/v1/ad-campaigns/\(campaignId)",
            body: Body(name: name, budget: budget, objective: objective, bidStrategy: bidStrategy)
        )
    }

    /// Delete a campaign.
    public func delete(_ campaignId: String) async throws {
        try await client.delete("/v1/ad-campaigns/\(campaignId)")
    }

    /// Duplicate a campaign with an optional override name.
    public func duplicate(_ campaignId: String, name: String? = nil) async throws -> AdCampaign {
        struct Body: Encodable { let name: String? }
        return try await client.post("/v1/ad-campaigns/\(campaignId)/duplicate", body: Body(name: name))
    }

    /// Bulk pause / resume / archive campaigns.
    public func bulkSetStatus(_ campaignIds: [String], status: AdCampaignStatus) async throws {
        struct Body: Encodable {
            let campaignIds: [String]
            let status: AdCampaignStatus
        }
        try await client.post("/v1/ad-campaigns/bulk-status", body: Body(campaignIds: campaignIds, status: status))
    }
}

public struct AdSetsResource: Sendable {
    let client: HTTPClient

    /// Edit ad-set fields.
    public func update(
        _ adSetId: String,
        name: String? = nil,
        budget: AnyCodable? = nil,
        targeting: AnyCodable? = nil,
        bidStrategy: String? = nil
    ) async throws {
        struct Body: Encodable {
            let name: String?
            let budget: AnyCodable?
            let targeting: AnyCodable?
            let bidStrategy: String?
        }
        try await client.patch(
            "/v1/ad-sets/\(adSetId)",
            body: Body(name: name, budget: budget, targeting: targeting, bidStrategy: bidStrategy)
        )
    }

    /// Pause / resume / archive an ad set.
    public func setStatus(_ adSetId: String, status: AdCampaignStatus) async throws {
        struct Body: Encodable { let status: AdCampaignStatus }
        try await client.post("/v1/ad-sets/\(adSetId)/status", body: Body(status: status))
    }
}
