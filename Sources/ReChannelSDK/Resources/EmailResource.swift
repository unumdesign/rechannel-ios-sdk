import Foundation

public struct EmailResource: Sendable {
    let client: HTTPClient

    /// Connect an email domain.
    public func connect(_ params: ConnectEmailParams) async throws -> EmailIntegration {
        try await client.post("/v1/email/integrations/connect", body: params)
    }

    /// List email integrations.
    public func list(cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<EmailIntegration> {
        try await client.get("/v1/email/integrations", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Get an email integration by ID.
    public func get(integrationId: String) async throws -> EmailIntegration {
        try await client.get("/v1/email/integrations/\(integrationId)")
    }

    /// Get DNS records required for domain verification.
    public func getDnsRecords(integrationId: String) async throws -> [DnsRecord] {
        try await client.get("/v1/email/integrations/\(integrationId)/dns-records")
    }

    /// Verify domain DNS records.
    public func verify(integrationId: String) async throws -> EmailIntegration {
        try await client.postReturning("/v1/email/integrations/\(integrationId)/verify")
    }

    /// Send an email via an integration.
    public func send(integrationId: String, params: SendEmailParams) async throws -> EmailMessage {
        try await client.post("/v1/email/integrations/\(integrationId)/send", body: params)
    }

    /// List sent messages for an integration.
    public func listMessages(integrationId: String, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<EmailMessage> {
        try await client.get("/v1/email/integrations/\(integrationId)/messages", query: paginationQuery(cursor: cursor, limit: limit))
    }

    /// Delete an email integration.
    public func delete(integrationId: String) async throws {
        try await client.delete("/v1/email/integrations/\(integrationId)")
    }
}
