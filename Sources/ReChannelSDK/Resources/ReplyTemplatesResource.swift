import Foundation

/// Reply templates resource — saved canned replies for the inbox composer.
/// Endpoints scoped under `/v1/tenants/:tenantId/inbox/reply-templates`.
public struct ReplyTemplatesResource: Sendable {
    let client: HTTPClient

    public func list(scope: ReplyTemplateScope? = nil) async throws -> [ReplyTemplate] {
        var query: [String: String] = [:]
        if let scope { query["scope"] = scope.rawValue }
        let tenant = await client.getTenantId()
        return try await client.get(
            "/v1/tenants/\(tenant)/inbox/reply-templates",
            query: query
        )
    }

    public func create(
        title: String,
        body: String,
        scope: ReplyTemplateScope,
        tags: [String]? = nil
    ) async throws -> ReplyTemplate {
        let tenant = await client.getTenantId()
        return try await client.post(
            "/v1/tenants/\(tenant)/inbox/reply-templates",
            body: CreateReplyTemplateBody(title: title, body: body, scope: scope, tags: tags)
        )
    }

    public func update(
        id: String,
        title: String? = nil,
        body: String? = nil,
        scope: ReplyTemplateScope? = nil,
        tags: [String]? = nil
    ) async throws -> ReplyTemplate {
        let tenant = await client.getTenantId()
        return try await client.patch(
            "/v1/tenants/\(tenant)/inbox/reply-templates/\(id)",
            body: UpdateReplyTemplateBody(title: title, body: body, scope: scope, tags: tags)
        )
    }

    public func delete(id: String) async throws {
        let tenant = await client.getTenantId()
        try await client.delete("/v1/tenants/\(tenant)/inbox/reply-templates/\(id)")
    }
}
