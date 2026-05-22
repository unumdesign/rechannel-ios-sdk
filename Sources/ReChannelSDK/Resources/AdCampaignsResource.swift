import Foundation

public enum AdCampaignStatus: String, Codable, Sendable {
    case active
    case paused
}

/// Per-call context: which ad platform owns the campaign/ad set, and (for
/// Meta) which AdAccount the API should consult to find the access token.
public struct AdLifecycleContext: Sendable {
    public let platform: AdPlatform
    /// Required when `platform == .meta`. Optional otherwise.
    public let zernioAdAccountId: String?

    public init(platform: AdPlatform, zernioAdAccountId: String? = nil) {
        self.platform = platform
        self.zernioAdAccountId = zernioAdAccountId
    }
}

public struct AdCampaignsResource: Sendable {
    let client: HTTPClient

    /// Pause or resume a campaign.
    public func setStatus(
        _ campaignId: String,
        ctx: AdLifecycleContext,
        status: AdCampaignStatus
    ) async throws -> AdCampaign {
        struct Body: Encodable {
            let platform: AdPlatform
            let zernioAdAccountId: String?
            let status: AdCampaignStatus
        }
        return try await client.post(
            "/v1/ad-campaigns/\(campaignId)/status",
            body: Body(platform: ctx.platform, zernioAdAccountId: ctx.zernioAdAccountId, status: status)
        )
    }

    /// Edit campaign fields.
    public func update(
        _ campaignId: String,
        ctx: AdLifecycleContext,
        name: String? = nil,
        budget: AnyCodable? = nil,
        bidStrategy: String? = nil
    ) async throws -> AdCampaign {
        struct Body: Encodable {
            let platform: AdPlatform
            let zernioAdAccountId: String?
            let name: String?
            let budget: AnyCodable?
            let bidStrategy: String?
        }
        return try await client.patch(
            "/v1/ad-campaigns/\(campaignId)",
            body: Body(
                platform: ctx.platform,
                zernioAdAccountId: ctx.zernioAdAccountId,
                name: name,
                budget: budget,
                bidStrategy: bidStrategy
            )
        )
    }

    /// Delete a campaign.
    public func delete(_ campaignId: String, ctx: AdLifecycleContext) async throws {
        try await client.delete("/v1/ad-campaigns/\(campaignId)")
    }

    /// Duplicate a campaign with an optional override name.
    public func duplicate(
        _ campaignId: String,
        ctx: AdLifecycleContext,
        name: String? = nil
    ) async throws -> AdCampaign {
        struct Body: Encodable {
            let platform: AdPlatform
            let zernioAdAccountId: String?
            let name: String?
        }
        return try await client.post(
            "/v1/ad-campaigns/\(campaignId)/duplicate",
            body: Body(platform: ctx.platform, zernioAdAccountId: ctx.zernioAdAccountId, name: name)
        )
    }

    /// Bulk pause or resume campaigns.
    public func bulkSetStatus(
        _ campaignIds: [String],
        ctx: AdLifecycleContext,
        status: AdCampaignStatus
    ) async throws {
        struct Body: Encodable {
            let platform: AdPlatform
            let zernioAdAccountId: String?
            let campaignIds: [String]
            let status: AdCampaignStatus
        }
        try await client.post(
            "/v1/ad-campaigns/bulk-status",
            body: Body(
                platform: ctx.platform,
                zernioAdAccountId: ctx.zernioAdAccountId,
                campaignIds: campaignIds,
                status: status
            )
        )
    }
}

public struct AdSetsResource: Sendable {
    let client: HTTPClient

    /// Edit ad-set fields.
    public func update(
        _ adSetId: String,
        ctx: AdLifecycleContext,
        name: String? = nil,
        budget: AnyCodable? = nil,
        bidStrategy: String? = nil,
        bidAmount: Double? = nil
    ) async throws {
        struct Body: Encodable {
            let platform: AdPlatform
            let zernioAdAccountId: String?
            let name: String?
            let budget: AnyCodable?
            let bidStrategy: String?
            let bidAmount: Double?
        }
        try await client.patch(
            "/v1/ad-sets/\(adSetId)",
            body: Body(
                platform: ctx.platform,
                zernioAdAccountId: ctx.zernioAdAccountId,
                name: name,
                budget: budget,
                bidStrategy: bidStrategy,
                bidAmount: bidAmount
            )
        )
    }

    /// Pause or resume an ad set.
    public func setStatus(_ adSetId: String, ctx: AdLifecycleContext, status: AdCampaignStatus) async throws {
        struct Body: Encodable {
            let platform: AdPlatform
            let zernioAdAccountId: String?
            let status: AdCampaignStatus
        }
        try await client.post(
            "/v1/ad-sets/\(adSetId)/status",
            body: Body(platform: ctx.platform, zernioAdAccountId: ctx.zernioAdAccountId, status: status)
        )
    }
}
