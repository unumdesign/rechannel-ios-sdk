import Foundation

public struct PushResource: Sendable {
    let client: HTTPClient

    /// Send a push notification to a user by externalId.
    public func send(_ params: SendPushParams) async throws -> PushNotification {
        try await client.post("/v1/engage/push/send", body: params)
    }

    /// Send a push notification to a specific device token.
    public func sendRaw(_ params: SendRawPushParams) async throws -> PushNotification {
        try await client.post("/v1/engage/push/send-raw", body: params)
    }

    /// Get a push notification by ID.
    public func get(notificationId: String) async throws -> PushNotification {
        try await client.get("/v1/engage/push/\(notificationId)")
    }

    /// List push notifications.
    public func list(externalUserId: String? = nil, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<PushNotification> {
        var query = paginationQuery(cursor: cursor, limit: limit)
        if let externalUserId { query["externalUserId"] = externalUserId }
        return try await client.get("/v1/engage/push", query: query)
    }

    // MARK: - FCM Config

    /// Set or update the Firebase Cloud Messaging configuration.
    public func setConfig(_ config: PushConfig) async throws {
        try await client.post("/v1/engage/push/config", body: config)
    }

    /// Get the current FCM configuration.
    public func getConfig() async throws -> PushConfig {
        try await client.get("/v1/engage/push/config")
    }

    /// Delete the FCM configuration.
    public func deleteConfig() async throws {
        try await client.delete("/v1/engage/push/config")
    }

    // MARK: - Frequency & Quiet Hours

    /// Set the frequency cap.
    public func setFrequencyCap(_ cap: FrequencyCap) async throws {
        try await client.put("/v1/engage/frequency-cap", body: cap)
    }

    /// Get the current frequency cap.
    public func getFrequencyCap() async throws -> FrequencyCap {
        try await client.get("/v1/engage/frequency-cap")
    }

    /// Set quiet hours configuration.
    public func setQuietHours(_ quietHours: QuietHours) async throws {
        try await client.put("/v1/engage/quiet-hours", body: quietHours)
    }

    /// Get the current quiet hours configuration.
    public func getQuietHours() async throws -> QuietHours {
        try await client.get("/v1/engage/quiet-hours")
    }
}
