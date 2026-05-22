import Foundation

public struct SocialResource: Sendable {
    let client: HTTPClient

    // MARK: - Providers

    /// List available social providers and their capabilities.
    public func listProviders() async throws -> [SocialProvider] {
        try await client.get("/v1/social/providers")
    }

    // MARK: - Auth Sessions

    /// Start an OAuth session to connect or reconnect a social account.
    public func createAuthSession(_ params: CreateAuthSessionParams) async throws -> AuthSession {
        try await client.post("/v1/social/auth-sessions", body: params)
    }

    /// Get the current state of an auth session.
    public func getAuthSession(id: String) async throws -> AuthSession {
        try await client.get("/v1/social/auth-sessions/\(id)")
    }

    /// Select accounts from a multi-account OAuth flow.
    public func selectAccounts(sessionId: String, params: SelectAccountsParams) async throws -> AuthSession {
        try await client.post("/v1/social/auth-sessions/\(sessionId)/selections", body: params)
    }

    /// User skipped OAuth — mint a pending_auth Integration placeholder for this session
    /// so drafts can attach to it. When the user later completes OAuth, the placeholder
    /// is upgraded in place to an active integration and any drafts become publishable.
    public func skipAuthSession(sessionId: String) async throws -> SkipAuthSessionResult {
        try await client.postReturning("/v1/social/auth-sessions/\(sessionId)/skip")
    }

    // MARK: - Integrations

    /// List connected social integrations.
    public func listIntegrations(
        provider: String? = nil,
        status: IntegrationStatus? = nil,
        accountType: String? = nil
    ) async throws -> [SocialIntegration] {
        var query: [String: String] = [:]
        if let provider { query["provider"] = provider }
        if let status { query["status"] = status.rawValue }
        if let accountType { query["accountType"] = accountType }
        return try await client.get("/v1/social/integrations", query: query)
    }

    /// Get a social integration by ID.
    public func getIntegration(id: String) async throws -> SocialIntegration {
        try await client.get("/v1/social/integrations/\(id)")
    }

    /// Update an integration's metadata.
    public func updateIntegration(id: String, params: UpdateIntegrationParams) async throws -> SocialIntegration {
        try await client.patch("/v1/social/integrations/\(id)", body: params)
    }

    /// Force a token refresh for an integration.
    public func refreshIntegration(id: String) async throws -> SocialIntegration {
        try await client.postReturning("/v1/social/integrations/\(id)/refresh")
    }

    /// Fetch provider-specific resources (boards, pages, etc.).
    public func getResource(integrationId: String, resourceKey: String) async throws -> AnyCodable {
        try await client.get("/v1/social/integrations/\(integrationId)/resources/\(resourceKey)")
    }

    /// Disconnect a social integration.
    public func disconnectIntegration(id: String) async throws {
        try await client.delete("/v1/social/integrations/\(id)")
    }

    // MARK: - Posts

    /// Create a draft or scheduled post.
    public func createPost(_ params: CreatePostParams) async throws -> SocialPost {
        try await client.post("/v1/social/posts", body: params)
    }

    /// List social posts.
    public func listPosts(integrationId: String? = nil, cursor: String? = nil, limit: Int? = nil) async throws -> PaginatedResponse<SocialPost> {
        var query = paginationQuery(cursor: cursor, limit: limit)
        if let integrationId { query["integrationId"] = integrationId }
        return try await client.get("/v1/social/posts", query: query)
    }

    /// Get a social post by ID.
    public func getPost(id: String) async throws -> SocialPost {
        try await client.get("/v1/social/posts/\(id)")
    }

    /// Publish a post immediately.
    public func publishPost(id: String) async throws -> SocialPost {
        try await client.postReturning("/v1/social/posts/\(id)/publish")
    }

    /// Zero-config "hello world" — auto-pick the first active integration on the
    /// active tenant and publish a short test post. Useful for smoke-testing the
    /// publish loop end to end. Pass `integrationId` to target a specific
    /// integration, or `text` to customize the message body. Returns the
    /// published post including the live platform URL.
    public func publishTestPost(integrationId: String? = nil, text: String? = nil) async throws -> PublishTestPostResponse {
        try await client.post("/v1/social/posts/test", body: PublishTestPostRequest(integrationId: integrationId, text: text))
    }

    // MARK: - Insights

    /// Get account-level insights for an integration.
    public func getAccountInsights(integrationId: String, since: String? = nil, until: String? = nil) async throws -> [String: AnyCodable] {
        var query: [String: String] = [:]
        if let since { query["since"] = since }
        if let until { query["until"] = until }
        return try await client.get("/v1/social/integrations/\(integrationId)/insights/account", query: query.isEmpty ? nil : query)
    }

    /// Get post-level insights.
    public func getPostInsights(postId: String) async throws -> [String: AnyCodable] {
        try await client.get("/v1/social/posts/\(postId)/insights")
    }

    // MARK: - Advanced Analytics

    /// Get daily metrics time-series across all posts.
    public func getDailyMetrics(
        platform: String? = nil,
        fromDate: String? = nil,
        toDate: String? = nil,
        source: String? = nil
    ) async throws -> DailyMetrics {
        var query: [String: String] = [:]
        if let platform { query["platform"] = platform }
        if let fromDate { query["fromDate"] = fromDate }
        if let toDate { query["toDate"] = toDate }
        if let source { query["source"] = source }
        return try await client.get("/v1/social/insights/daily-metrics", query: query.isEmpty ? nil : query)
    }

    /// Get follower stats and growth trends.
    public func getFollowerStats(
        accountIds: String? = nil,
        fromDate: String? = nil,
        toDate: String? = nil,
        granularity: String? = nil
    ) async throws -> FollowerStats {
        var query: [String: String] = [:]
        if let accountIds { query["accountIds"] = accountIds }
        if let fromDate { query["fromDate"] = fromDate }
        if let toDate { query["toDate"] = toDate }
        if let granularity { query["granularity"] = granularity }
        return try await client.get("/v1/social/insights/follower-stats", query: query.isEmpty ? nil : query)
    }

    /// Get best time to post based on engagement data.
    public func getBestTimeToPost(
        platform: String? = nil,
        source: String? = nil
    ) async throws -> BestTimeToPost {
        var query: [String: String] = [:]
        if let platform { query["platform"] = platform }
        if let source { query["source"] = source }
        return try await client.get("/v1/social/insights/best-time-to-post", query: query.isEmpty ? nil : query)
    }

    /// Get content decay analysis.
    public func getContentDecay(
        platform: String? = nil,
        source: String? = nil
    ) async throws -> ContentDecay {
        var query: [String: String] = [:]
        if let platform { query["platform"] = platform }
        if let source { query["source"] = source }
        return try await client.get("/v1/social/insights/content-decay", query: query.isEmpty ? nil : query)
    }

    /// Get posting frequency vs engagement correlation.
    public func getPostingFrequency(
        platform: String? = nil,
        source: String? = nil
    ) async throws -> PostingFrequency {
        var query: [String: String] = [:]
        if let platform { query["platform"] = platform }
        if let source { query["source"] = source }
        return try await client.get("/v1/social/insights/posting-frequency", query: query.isEmpty ? nil : query)
    }

    /// Get engagement timeline for a single post.
    public func getPostTimeline(
        postId: String,
        fromDate: String? = nil,
        toDate: String? = nil
    ) async throws -> PostTimeline {
        var query: [String: String] = [:]
        if let fromDate { query["fromDate"] = fromDate }
        if let toDate { query["toDate"] = toDate }
        return try await client.get("/v1/social/posts/\(postId)/insights/timeline", query: query.isEmpty ? nil : query)
    }
}
