import Foundation

public struct PoliciesResource: Sendable {
    let client: HTTPClient

    /// List re/channel-maintained policy templates available to install.
    public func listLibrary() async throws -> PolicyLibraryListResponse {
        try await client.get("/v1/policies/library")
    }

    /// Install one or more library policies into the tenant.
    public func installLibrary(_ params: InstallPolicyLibraryParams) async throws -> InstallPolicyLibraryResponse {
        try await client.post("/v1/policies/library/install", body: params)
    }

    public func create(_ params: CreatePolicyParams) async throws -> Policy {
        try await client.post("/v1/policies", body: params)
    }

    public func list(scope: PolicyScope? = nil, active: Bool? = nil, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<Policy> {
        var query = paginationQuery(cursor: cursor, limit: limit)
        if let scope { query["scope"] = scope.rawValue }
        if let active { query["active"] = active ? "true" : "false" }
        return try await client.get("/v1/policies", query: query)
    }

    public func get(id: String) async throws -> Policy {
        try await client.get("/v1/policies/\(id)")
    }

    public func update(id: String, params: UpdatePolicyParams) async throws -> Policy {
        try await client.patch("/v1/policies/\(id)", body: params)
    }

    public func delete(id: String) async throws {
        try await client.delete("/v1/policies/\(id)")
    }
}
