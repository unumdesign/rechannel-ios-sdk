import Foundation

public struct AttributionResource: Sendable {
    let client: HTTPClient

    /// Attribution rollup over the Event stream.
    public func summarize(
        campaignId: String? = nil,
        journeyId: String? = nil,
        partnerId: String? = nil,
        channelType: String? = nil,
        conversionEvent: String? = nil,
        since: String? = nil,
        until: String? = nil
    ) async throws -> AttributionSummary {
        var query: [String: String] = [:]
        if let campaignId { query["campaignId"] = campaignId }
        if let journeyId { query["journeyId"] = journeyId }
        if let partnerId { query["partnerId"] = partnerId }
        if let channelType { query["channelType"] = channelType }
        if let conversionEvent { query["conversionEvent"] = conversionEvent }
        if let since { query["since"] = since }
        if let until { query["until"] = until }
        return try await client.get("/v1/attribution", query: query)
    }

    /// Rebuild the attribution rollup for one UTC day (`YYYY-MM-DD`). Idempotent.
    public func rebuildRollup(day: String) async throws -> RollupRebuildResponse {
        try await client.post("/v1/attribution/rollup/rebuild", body: ["day": day])
    }
}

public struct RollupRebuildResponse: Codable, Sendable {
    public let day: String
    public let rowsWritten: Int
}
