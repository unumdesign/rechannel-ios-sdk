import Foundation

/// Ad platforms supported by Zernio.
public enum AdPlatform: String, Codable, Sendable {
    case meta
    case tiktok
    case google
    case linkedin
    case pinterest
    case twitter
}

public enum AdAccountStatus: String, Codable, Sendable {
    case active
    case actionRequired = "action_required"
    case disconnected
    case error
}

public struct AdAccount: Codable, Sendable {
    public let tenantId: String
    public let platform: AdPlatform
    public let zernioAdAccountId: String
    public let platformAdAccountId: String?
    public let platformAdAccountName: String?
    public let businessCenterId: String?
    public let currency: String?
    public let timezone: String?
    public let status: AdAccountStatus
    public let zernioAccountId: String?
    public let scopes: [String]
    public let connectedAt: String?
}

public struct ConnectAdAccountResponse: Codable, Sendable {
    public let connectUrl: String?
    public let zernioProfileId: String
}

public struct AdCampaign: Codable, Sendable {
    public let id: String?
    public let name: String?
    public let status: String?
    public let objective: String?
    public let bidStrategy: String?
    public let platformAdAccountId: String?
    public let platformCampaignId: String?
    public let campaignName: String?
    public let budget: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case status
        case objective
        case bidStrategy
        case platformAdAccountId
        case platformCampaignId
        case campaignName
        case budget
    }
}

public struct Ad: Codable, Sendable {
    public let id: String?
    public let name: String?
    public let status: String?
    public let campaignId: String?
    public let adSetId: String?
    public let creative: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, status, campaignId, adSetId, creative
    }
}

public struct AdTimelinePoint: Codable, Sendable {
    public let date: String
    public let spend: Double?
    public let impressions: Int?
    public let clicks: Int?
    public let ctr: Double?
    public let cpc: Double?
    public let cpm: Double?
}

public struct AdTargetingLocation: Codable, Sendable {
    public let id: String
    public let name: String
    public let type: String?
    public let countryCode: String?
}

public struct BusinessCenter: Codable, Sendable {
    public let id: String
    public let name: String
}

public struct AdAccountsResource: Sendable {
    let client: HTTPClient

    /// Start the Zernio OAuth handshake for an ads platform.
    public func connect(platform: AdPlatform, redirectURI: String) async throws -> ConnectAdAccountResponse {
        struct Body: Encodable { let platform: AdPlatform; let redirectUri: String }
        return try await client.post("/v1/ad-accounts/connect", body: Body(platform: platform, redirectUri: redirectURI))
    }

    /// List connected ad accounts for the active tenant.
    public func list(platform: AdPlatform? = nil) async throws -> [AdAccount] {
        var query: [String: String] = [:]
        if let platform { query["platform"] = platform.rawValue }
        return try await client.get("/v1/ad-accounts", query: query.isEmpty ? nil : query)
    }

    /// Get a single ad account.
    public func get(_ zernioAdAccountId: String) async throws -> AdAccount {
        try await client.get("/v1/ad-accounts/\(zernioAdAccountId)")
    }

    /// List campaigns under an ad account.
    public func listCampaigns(
        _ zernioAdAccountId: String,
        status: String? = nil,
        limit: Int? = nil,
        page: Int? = nil
    ) async throws -> [AdCampaign] {
        var query: [String: String] = [:]
        if let status { query["status"] = status }
        if let limit { query["limit"] = String(limit) }
        if let page { query["page"] = String(page) }
        return try await client.get("/v1/ad-accounts/\(zernioAdAccountId)/campaigns", query: query.isEmpty ? nil : query)
    }

    /// List ads under an ad account.
    public func listAds(
        _ zernioAdAccountId: String,
        status: String? = nil,
        limit: Int? = nil,
        page: Int? = nil
    ) async throws -> [Ad] {
        var query: [String: String] = [:]
        if let status { query["status"] = status }
        if let limit { query["limit"] = String(limit) }
        if let page { query["page"] = String(page) }
        return try await client.get("/v1/ad-accounts/\(zernioAdAccountId)/ads", query: query.isEmpty ? nil : query)
    }

    /// Spend / performance timeline.
    public func getTimeline(
        _ zernioAdAccountId: String,
        fromDate: String,
        toDate: String,
        granularity: String? = nil
    ) async throws -> [AdTimelinePoint] {
        var query: [String: String] = ["fromDate": fromDate, "toDate": toDate]
        if let granularity { query["granularity"] = granularity }
        return try await client.get("/v1/ad-accounts/\(zernioAdAccountId)/timeline", query: query)
    }

    /// TikTok business centers under an ad account.
    public func listBusinessCenters(_ zernioAdAccountId: String) async throws -> [BusinessCenter] {
        try await client.get("/v1/ad-accounts/\(zernioAdAccountId)/business-centers")
    }

    /// Search ad-targeting locations (typeahead).
    public func searchTargetingLocations(
        _ zernioAdAccountId: String,
        query q: String
    ) async throws -> [AdTargetingLocation] {
        try await client.get("/v1/ad-accounts/\(zernioAdAccountId)/targeting/locations", query: ["q": q])
    }

    /// TikTok-only: configure brand identity for the ad account.
    public func configureTikTokBrandIdentity(
        _ zernioAdAccountId: String,
        brandIdentityId: String
    ) async throws {
        struct Body: Encodable { let brandIdentityId: String }
        try await client.post(
            "/v1/ad-accounts/\(zernioAdAccountId)/tiktok-brand-identity",
            body: Body(brandIdentityId: brandIdentityId)
        )
    }
}
