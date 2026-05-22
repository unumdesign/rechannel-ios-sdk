import Foundation

public enum TenantMemoryScope: String, Codable, Sendable {
    case brand
    case campaign
    case ops
    case constraint
}

public struct TenantMemoryRow: Codable, Sendable {
    public let id: String
    public let tenantId: String
    public let brandId: String?
    public let key: String
    public let value: String
    public let scope: TenantMemoryScope
    public let source: String
    public let createdBy: String
    public let createdAt: String
    public let updatedAt: String
}

public struct TenantMatch: Codable, Sendable {
    public let tenantId: String
    public let name: String
    public let confidence: Double
    public let reason: String
}

public struct TenantSnapshotBrand: Codable, Sendable {
    public let id: String
    public let name: String
}

public struct TenantSnapshotIntegration: Codable, Sendable {
    public let id: String
    public let platform: String
    public let displayName: String?
    public let status: String
}

public struct TenantSnapshot: Codable, Sendable {
    public let tenantId: String
    public let name: String
    public let brands: [TenantSnapshotBrand]
    public let integrations: [TenantSnapshotIntegration]
    public let lastActivity: String?
}

public struct ResolveContextResponse: Codable, Sendable {
    public let match: TenantMatch?
    public let snapshot: TenantSnapshot?
    public let memory: [TenantMemoryRow]?
    public let alternatives: [TenantMatch]?
    public let suggest: String?
}

public struct RememberRequest: Codable, Sendable {
    public let key: String
    public let value: String
    public let scope: TenantMemoryScope
    public let brandId: String?
    public let source: String?

    public init(
        key: String,
        value: String,
        scope: TenantMemoryScope,
        brandId: String? = nil,
        source: String? = nil,
    ) {
        self.key = key
        self.value = value
        self.scope = scope
        self.brandId = brandId
        self.source = source
    }
}

public struct ForgetResponse: Codable, Sendable {
    public let deleted: Bool
    public let key: String
}

public struct TenantMemoryResource: Sendable {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    /// Resolve a natural-language intent to the best-matching tenant + a
    /// compact snapshot + any persisted memory.
    public func resolveContext(intent: String) async throws -> ResolveContextResponse {
        struct Body: Codable { let intent: String }
        return try await client.post("/v1/tenant-memory/resolve", body: Body(intent: intent))
    }

    /// Upsert a durable per-tenant memory by `(tenantId, brandId?, key)`.
    public func remember(
        key: String,
        value: String,
        scope: TenantMemoryScope,
        brandId: String? = nil,
        source: String? = nil,
    ) async throws -> TenantMemoryRow {
        try await client.post(
            "/v1/tenant-memory",
            body: RememberRequest(key: key, value: value, scope: scope, brandId: brandId, source: source),
        )
    }

    /// List memories for the active tenant. With `brandId` + `includeTenantLevel:
    /// true`, returns brand-specific + tenant-level rows merged newest-first.
    public func recall(
        scope: TenantMemoryScope? = nil,
        brandId: String? = nil,
        includeTenantLevel: Bool = false,
        query: String? = nil,
        limit: Int? = nil,
    ) async throws -> [TenantMemoryRow] {
        var q: [String: String] = [:]
        if let scope { q["scope"] = scope.rawValue }
        if let brandId { q["brandId"] = brandId }
        if includeTenantLevel { q["includeTenantLevel"] = "true" }
        if let query { q["query"] = query }
        if let limit { q["limit"] = String(limit) }
        return try await client.get("/v1/tenant-memory", query: q.isEmpty ? nil : q)
    }

    /// Delete a memory by key. Prefer **updating** via `remember(...)` over forgetting.
    public func forget(key: String, brandId: String? = nil) async throws -> ForgetResponse {
        let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? key
        var path = "/v1/tenant-memory/\(encodedKey)"
        if let brandId {
            let encoded = brandId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? brandId
            path += "?brandId=\(encoded)"
        }
        return try await client.deleteReturning(path)
    }
}
