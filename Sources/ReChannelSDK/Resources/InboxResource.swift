import Foundation

/// Inbox resource — comments and DMs received via Zernio webhooks ingested
/// by re-channel. All endpoints are scoped under `/v1/tenants/:tenantId/inbox`.
public struct InboxResource: Sendable {
    let client: HTTPClient

    // MARK: - Comments

    public func listComments(
        brandId: String? = nil,
        lateAccountId: String? = nil,
        unreadOnly: Bool? = nil,
        before: String? = nil,
        limit: Int? = nil
    ) async throws -> [InboxComment] {
        var query: [String: String] = [:]
        if let brandId { query["brandId"] = brandId }
        if let lateAccountId { query["lateAccountId"] = lateAccountId }
        if let unreadOnly { query["unreadOnly"] = unreadOnly ? "true" : "false" }
        if let before { query["before"] = before }
        if let limit { query["limit"] = String(limit) }
        let tenant = await client.getTenantId()
        return try await client.get("/v1/tenants/\(tenant)/inbox/comments", query: query)
    }

    public func unreadCount(brandId: String? = nil) async throws -> CountResponse {
        var query: [String: String] = [:]
        if let brandId { query["brandId"] = brandId }
        let tenant = await client.getTenantId()
        return try await client.get("/v1/tenants/\(tenant)/inbox/comments/unread-count", query: query)
    }

    public func markCommentRead(commentId: String) async throws -> InboxComment {
        let tenant = await client.getTenantId()
        return try await client.post(
            "/v1/tenants/\(tenant)/inbox/comments/\(commentId)/read",
            body: EmptyBody()
        )
    }

    public func replyToComment(commentId: String, message: String) async throws -> InboxComment {
        let tenant = await client.getTenantId()
        return try await client.post(
            "/v1/tenants/\(tenant)/inbox/comments/\(commentId)/reply",
            body: InboxReplyBody(message: message)
        )
    }

    public func privateReplyToComment(commentId: String, message: String) async throws -> InboxComment {
        let tenant = await client.getTenantId()
        return try await client.post(
            "/v1/tenants/\(tenant)/inbox/comments/\(commentId)/private-reply",
            body: InboxReplyBody(message: message)
        )
    }

    public func hideComment(commentId: String, hidden: Bool) async throws {
        let tenant = await client.getTenantId()
        let _: EmptyBody = try await client.post(
            "/v1/tenants/\(tenant)/inbox/comments/\(commentId)/hide",
            body: InboxHideBody(hidden: hidden)
        )
    }

    public func deleteComment(commentId: String) async throws {
        let tenant = await client.getTenantId()
        try await client.delete("/v1/tenants/\(tenant)/inbox/comments/\(commentId)")
    }

    // MARK: - DMs

    public func listConversations(brandId: String? = nil, limit: Int? = nil) async throws -> [InboxConversation] {
        var query: [String: String] = [:]
        if let brandId { query["brandId"] = brandId }
        if let limit { query["limit"] = String(limit) }
        let tenant = await client.getTenantId()
        return try await client.get("/v1/tenants/\(tenant)/inbox/conversations", query: query)
    }

    public func listMessages(conversationId: String, limit: Int? = nil) async throws -> [InboxMessage] {
        var query: [String: String] = [:]
        if let limit { query["limit"] = String(limit) }
        let tenant = await client.getTenantId()
        return try await client.get(
            "/v1/tenants/\(tenant)/inbox/conversations/\(conversationId)/messages",
            query: query
        )
    }

    public func sendMessage(conversationId: String, message: String) async throws {
        let tenant = await client.getTenantId()
        let _: EmptyBody = try await client.post(
            "/v1/tenants/\(tenant)/inbox/conversations/\(conversationId)/messages",
            body: InboxReplyBody(message: message)
        )
    }

    public func markConversationRead(conversationId: String) async throws -> InboxConversation {
        let tenant = await client.getTenantId()
        return try await client.post(
            "/v1/tenants/\(tenant)/inbox/conversations/\(conversationId)/read",
            body: EmptyBody()
        )
    }
}
