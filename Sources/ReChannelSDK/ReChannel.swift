import Foundation

/// Configuration for the ReChannel SDK.
public struct ReChannelConfig {
    /// JWT Bearer token.
    public var token: String?
    /// API key (alternative to token).
    public var apiKey: String?
    /// Tenant ID — required for all authenticated requests.
    public var tenantId: String
    /// Base URL of the reChannel API.
    public var baseURL: String
    /// Idempotency-Key handling for mutating requests. Default: `.auto`.
    public var idempotency: IdempotencyMode

    public init(
        token: String? = nil,
        apiKey: String? = nil,
        tenantId: String,
        baseURL: String = "https://rc-api.rift.wyrld.com",
        idempotency: IdempotencyMode = .auto
    ) {
        self.token = token
        self.apiKey = apiKey
        self.tenantId = tenantId
        self.baseURL = baseURL
        self.idempotency = idempotency
    }
}

/// Main entry point for the ReChannel SDK.
public final class ReChannel: Sendable {
    private let client: HTTPClient

    public let users: UsersResource
    public let events: EventsResource
    public let accessTokens: AccessTokensResource
    public let audiences: AudiencesResource
    public let channels: ChannelsResource
    public let messages: MessagesResource
    public let partners: PartnersResource
    public let policies: PoliciesResource
    public let campaigns: CampaignsResource
    public let journeys: JourneysResource
    public let push: PushResource
    public let social: SocialResource
    public let email: EmailResource
    public let analytics: AnalyticsResource
    public let attribution: AttributionResource
    public let webhookSubscriptions: WebhookSubscriptionsResource
    public let inbox: InboxResource
    public let jobs: JobsResource
    public let capabilities: CapabilitiesResource
    public let replyTemplates: ReplyTemplatesResource
    public let adAccounts: AdAccountsResource
    public let adCampaigns: AdCampaignsResource
    public let adSets: AdSetsResource
    public let ai: AiResource
    public let tenantMemory: TenantMemoryResource

    public init(config: ReChannelConfig) throws {
        guard config.token != nil || config.apiKey != nil else {
            throw ReChannelError.missingCredentials
        }

        let client = HTTPClient(
            baseURL: config.baseURL,
            token: config.token,
            apiKey: config.apiKey,
            tenantId: config.tenantId,
            idempotency: config.idempotency
        )

        self.client = client
        self.users = UsersResource(client: client)
        self.events = EventsResource(client: client)
        self.accessTokens = AccessTokensResource(client: client)
        self.audiences = AudiencesResource(client: client)
        self.channels = ChannelsResource(client: client)
        self.messages = MessagesResource(client: client)
        self.partners = PartnersResource(client: client)
        self.policies = PoliciesResource(client: client)
        self.campaigns = CampaignsResource(client: client)
        self.journeys = JourneysResource(client: client)
        self.push = PushResource(client: client)
        self.social = SocialResource(client: client)
        self.email = EmailResource(client: client)
        self.analytics = AnalyticsResource(client: client)
        self.attribution = AttributionResource(client: client)
        self.webhookSubscriptions = WebhookSubscriptionsResource(client: client)
        self.inbox = InboxResource(client: client)
        self.jobs = JobsResource(client: client)
        self.capabilities = CapabilitiesResource(client: client)
        self.replyTemplates = ReplyTemplatesResource(client: client)
        self.adAccounts = AdAccountsResource(client: client)
        self.adCampaigns = AdCampaignsResource(client: client)
        self.adSets = AdSetsResource(client: client)
        self.ai = AiResource(client: client)
        self.tenantMemory = TenantMemoryResource(client: client)
    }

    /// Update the auth token.
    public func setToken(_ token: String) async {
        await client.setToken(token)
    }

    /// Update the tenant ID.
    public func setTenantId(_ tenantId: String) async {
        await client.setTenantId(tenantId)
    }

    /// Return the current developer, their active tenant, and role.
    public func getMe() async throws -> MeResponse {
        try await client.get("/v1/me")
    }

    /// List all workspaces the current developer is a member of.
    public func listWorkspaces() async throws -> [Workspace] {
        try await client.get("/v1/me/workspaces")
    }

    /// Create a new workspace (tenant) and grant the current developer ownership.
    /// Mirrors the `rechannel_create_tenant` MCP tool.
    public func createWorkspace(name: String, plan: TenantPlan? = nil) async throws -> Workspace {
        struct Body: Encodable {
            let name: String
            let plan: TenantPlan?
        }
        return try await client.post("/v1/me/workspaces", body: Body(name: name, plan: plan))
    }

    /// Login and return an authenticated ReChannel client.
    public static func login(
        email: String,
        password: String,
        baseURL: String = "https://rc-api.rift.wyrld.com"
    ) async throws -> (client: ReChannel, auth: AuthResponse) {
        let url = URL(string: "\(baseURL)/v1/developer/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["email": email, "password": password])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let body = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let message = (body?["message"] as? String) ?? "Login failed"
            throw ReChannelError.authentication(message)
        }

        let auth = try JSONDecoder().decode(AuthResponse.self, from: data)
        let client = try ReChannel(config: ReChannelConfig(
            token: auth.token,
            tenantId: auth.tenantId,
            baseURL: baseURL
        ))

        return (client, auth)
    }

    /// Register a new developer account and return an authenticated client.
    public static func register(
        email: String,
        password: String,
        companyName: String? = nil,
        baseURL: String = "https://rc-api.rift.wyrld.com"
    ) async throws -> (client: ReChannel, auth: AuthResponse) {
        let url = URL(string: "\(baseURL)/v1/developer/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: String] = ["email": email, "password": password]
        if let companyName { body["companyName"] = companyName }
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let body = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let message = (body?["message"] as? String) ?? "Registration failed"
            throw ReChannelError.authentication(message)
        }

        let auth = try JSONDecoder().decode(AuthResponse.self, from: data)
        let client = try ReChannel(config: ReChannelConfig(
            token: auth.token,
            tenantId: auth.tenantId,
            baseURL: baseURL
        ))

        return (client, auth)
    }
}
