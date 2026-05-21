import Foundation

public struct PartnersResource: Sendable {
    let client: HTTPClient

    public func create(_ params: CreatePartnerParams) async throws -> Partner {
        try await client.post("/v1/partners", body: params)
    }

    public func list(type: PartnerType? = nil, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<Partner> {
        var query = paginationQuery(cursor: cursor, limit: limit)
        if let type { query["type"] = type.rawValue }
        return try await client.get("/v1/partners", query: query)
    }

    public func get(id: String) async throws -> Partner {
        try await client.get("/v1/partners/\(id)")
    }

    public func update(id: String, params: UpdatePartnerParams) async throws -> Partner {
        try await client.patch("/v1/partners/\(id)", body: params)
    }

    public func delete(id: String) async throws {
        try await client.delete("/v1/partners/\(id)")
    }
}
