import Foundation

public struct EventsResource: Sendable {
    let client: HTTPClient

    /// Track a single event.
    public func track(_ params: TrackEventParams) async throws -> UserEvent {
        try await client.post("/v1/engage/events", body: params)
    }

    /// Track a batch of events (max 500).
    public func trackBatch(_ events: [TrackEventParams]) async throws {
        try await client.post("/v1/engage/events/batch", body: ["events": events])
    }
}
