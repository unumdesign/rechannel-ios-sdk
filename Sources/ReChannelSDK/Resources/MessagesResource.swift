import Foundation

public struct MessagesResource: Sendable {
    let client: HTTPClient

    /// Create a message with channel-aware variants.
    public func create(_ params: CreateMessageParams) async throws -> Message {
        try await client.post("/v1/messages", body: params)
    }

    /// List messages.
    public func list(cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<Message> {
        try await client.get("/v1/messages", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Get a message by ID.
    public func get(id: String) async throws -> Message {
        try await client.get("/v1/messages/\(id)")
    }

    /// Update a message. Bumps version when variants change.
    public func update(id: String, params: UpdateMessageParams) async throws -> Message {
        try await client.patch("/v1/messages/\(id)", body: params)
    }

    /// Delete a message.
    public func delete(id: String) async throws {
        try await client.delete("/v1/messages/\(id)")
    }
}
