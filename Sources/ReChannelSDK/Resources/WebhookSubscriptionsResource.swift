import Foundation

public struct WebhookSubscriptionsResource: Sendable {
    let client: HTTPClient

    /// Create a webhook subscription. The plaintext signing `secret` is returned ONCE.
    public func create(_ params: CreateWebhookSubscriptionParams) async throws -> CreatedWebhookSubscription {
        try await client.post("/v1/webhook-subscriptions", body: params)
    }

    public func list() async throws -> WebhookSubscriptionListResponse {
        try await client.get("/v1/webhook-subscriptions")
    }

    public func get(id: String) async throws -> WebhookSubscription {
        try await client.get("/v1/webhook-subscriptions/\(id)")
    }

    public func update(id: String, params: UpdateWebhookSubscriptionParams) async throws -> WebhookSubscription {
        try await client.patch("/v1/webhook-subscriptions/\(id)", body: params)
    }

    public func delete(id: String) async throws {
        try await client.delete("/v1/webhook-subscriptions/\(id)")
    }

    /// Rotate the HMAC signing secret. Returns the new plaintext once.
    public func rotateSecret(id: String) async throws -> CreatedWebhookSubscription {
        try await client.postReturning("/v1/webhook-subscriptions/\(id)/rotate-secret")
    }

    public func listDeliveries(id: String, limit: Int? = nil) async throws -> WebhookDeliveryListResponse {
        var query: [String: String] = [:]
        if let limit { query["limit"] = String(limit) }
        return try await client.get("/v1/webhook-subscriptions/\(id)/deliveries", query: query)
    }
}
