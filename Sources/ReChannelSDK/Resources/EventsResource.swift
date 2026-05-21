import Foundation

public struct EventsResource: Sendable {
    let client: HTTPClient

    /// Track a single user-behavior event.
    public func track(_ params: TrackEventParams) async throws -> UserEvent {
        try await client.post("/v1/engage/events", body: params)
    }

    /// Track a batch of user-behavior events (max 500).
    public func trackBatch(_ events: [TrackEventParams]) async throws {
        try await client.post("/v1/engage/events/batch", body: ["events": events])
    }

    /// List events from the unified marketing event stream.
    public func list(
        category: EventCategory? = nil,
        subType: String? = nil,
        channel: String? = nil,
        campaignId: String? = nil,
        journeyId: String? = nil,
        partnerId: String? = nil,
        externalUserId: String? = nil,
        since: String? = nil,
        until: String? = nil,
        cursor: String? = nil,
        limit: Int? = nil
    ) async throws -> ListEventsResponse {
        var query: [String: String] = [:]
        if let category { query["category"] = category.rawValue }
        if let subType { query["subType"] = subType }
        if let channel { query["channel"] = channel }
        if let campaignId { query["campaignId"] = campaignId }
        if let journeyId { query["journeyId"] = journeyId }
        if let partnerId { query["partnerId"] = partnerId }
        if let externalUserId { query["externalUserId"] = externalUserId }
        if let since { query["since"] = since }
        if let until { query["until"] = until }
        if let cursor { query["cursor"] = cursor }
        if let limit { query["limit"] = String(limit) }
        return try await client.get("/v1/events", query: query)
    }

    /// Fetch a single event by id from the unified stream.
    public func get(id: String) async throws -> Event {
        try await client.get("/v1/events/\(id)")
    }
}
