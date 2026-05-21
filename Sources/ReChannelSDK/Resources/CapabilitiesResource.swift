import Foundation

public enum MediaType: String, Codable, Sendable {
    case image
    case video
    case carousel
    case document
    case link
    case poll
    case gif
}

public struct PostCapabilities: Codable, Sendable {
    public let maxCharacters: Int
    public let mediaTypes: [MediaType]
    public let maxMedia: Int
    public let videoMaxSeconds: Int?
    public let maxUploadBytes: Int64
}

public struct SchedulingCapabilities: Codable, Sendable {
    public let minLeadSeconds: Int
    public let maxLeadDays: Int
}

public struct PlatformCapabilities: Codable, Sendable {
    public let platform: String
    public let displayName: String
    public let post: PostCapabilities
    public let scheduling: SchedulingCapabilities
    public let lastVerifiedAt: String
}

public struct FrequencyCapabilities: Codable, Sendable {
    public let maxPostsPerDay: Int?
    public let maxScheduledQueueDepth: Int?
}

public struct TenantCapabilities: Codable, Sendable {
    public let tenantId: String
    public let platforms: [PlatformCapabilities]
    public let frequency: FrequencyCapabilities?
    public let generatedAt: String
}

/// Per-platform constraint discovery. Call this once per session and cache
/// the result for the (tenant, platform) pair to avoid learning rules by
/// failing a publish.
public struct CapabilitiesResource: Sendable {
    let client: HTTPClient

    public func get(platform: String? = nil) async throws -> TenantCapabilities {
        var query: [String: String] = [:]
        if let platform { query["platform"] = platform }
        return try await client.get("/v1/capabilities", query: query.isEmpty ? nil : query)
    }
}
