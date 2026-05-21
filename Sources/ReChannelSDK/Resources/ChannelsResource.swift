import Foundation

public struct ChannelsResource: Sendable {
    let client: HTTPClient

    /// List channels for the current tenant. Optionally filter by `type`.
    public func list(type: ChannelType? = nil) async throws -> ListChannelsResponse {
        var query: [String: String] = [:]
        if let type { query["type"] = type.rawValue }
        return try await client.get("/v1/channels", query: query)
    }

    /// Get a channel by ID.
    public func get(id: String) async throws -> Channel {
        try await client.get("/v1/channels/\(id)")
    }

    /// Per-send costs (USD) for each channel type — defaults + tenant overrides.
    public func listCosts() async throws -> ChannelCostList {
        try await client.get("/v1/channels/cost-overrides")
    }

    /// Override the per-send cost for a channel type.
    @discardableResult
    public func setCost(channelType: String, costPerSendUsd: Double) async throws -> [String: Bool] {
        try await client.put(
            "/v1/channels/cost-overrides/\(channelType)",
            body: ["costPerSendUsd": costPerSendUsd]
        )
    }

    /// Remove a cost override (revert to default).
    public func clearCost(channelType: String) async throws {
        try await client.delete("/v1/channels/cost-overrides/\(channelType)")
    }
}

public struct ChannelCostList: Codable, Sendable {
    public let defaults: [String: Double]
    public let overrides: [ChannelCostOverride]
}

public struct ChannelCostOverride: Codable, Sendable {
    public let channelType: String
    public let costPerSendUsd: Double
}
