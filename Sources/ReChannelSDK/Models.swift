import Foundation

// MARK: - Common

public struct PaginatedResponse<T: Decodable>: Decodable {
    public let data: [T]
    public let nextCursor: String?
    public let hasMore: Bool
    public let total: Int?
}

public struct EmptyBody: Codable {}

// MARK: - Users

public struct ChannelPreferences: Codable {
    public var email: Bool?
    public var push: Bool?
    public var sms: Bool?

    public init(email: Bool? = nil, push: Bool? = nil, sms: Bool? = nil) {
        self.email = email
        self.push = push
        self.sms = sms
    }
}

public struct DeviceToken: Codable {
    public let token: String
    public let platform: DevicePlatform
    public let appId: String?
    public let registeredAt: String?
}

public enum DevicePlatform: String, Codable {
    case apns
    case fcm
}

public struct UserProfile: Codable {
    public let _id: String
    public let externalId: String
    public let email: String?
    public let phone: String?
    public let firstName: String?
    public let lastName: String?
    public let timezone: String?
    public let locale: String?
    public let deviceTokens: [DeviceToken]
    public let customAttributes: [String: AnyCodable]?
    public let channelPreferences: ChannelPreferences
    public let createdAt: String
    public let updatedAt: String
}

public struct CreateUserProfileParams: Codable {
    public var externalId: String
    public var email: String?
    public var phone: String?
    public var firstName: String?
    public var lastName: String?
    public var timezone: String?
    public var locale: String?
    public var customAttributes: [String: AnyCodable]?
    public var channelPreferences: ChannelPreferences?

    public init(
        externalId: String,
        email: String? = nil,
        phone: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        timezone: String? = nil,
        locale: String? = nil,
        customAttributes: [String: AnyCodable]? = nil,
        channelPreferences: ChannelPreferences? = nil
    ) {
        self.externalId = externalId
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.timezone = timezone
        self.locale = locale
        self.customAttributes = customAttributes
        self.channelPreferences = channelPreferences
    }
}

public struct UpdateUserProfileParams: Codable {
    public var email: String?
    public var phone: String?
    public var firstName: String?
    public var lastName: String?
    public var timezone: String?
    public var locale: String?
    public var customAttributes: [String: AnyCodable]?
    public var channelPreferences: ChannelPreferences?

    public init(
        email: String? = nil,
        phone: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        timezone: String? = nil,
        locale: String? = nil,
        customAttributes: [String: AnyCodable]? = nil,
        channelPreferences: ChannelPreferences? = nil
    ) {
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.timezone = timezone
        self.locale = locale
        self.customAttributes = customAttributes
        self.channelPreferences = channelPreferences
    }
}

public struct RegisterDeviceTokenParams: Codable {
    public var token: String
    public var platform: DevicePlatform
    public var appId: String?

    public init(token: String, platform: DevicePlatform, appId: String? = nil) {
        self.token = token
        self.platform = platform
        self.appId = appId
    }
}

// MARK: - Webhook subscriptions

public struct WebhookFilter: Codable, Sendable {
    public var categories: [EventCategory]
    public var subTypes: [String]?
    public var channels: [String]?

    public init(categories: [EventCategory], subTypes: [String]? = nil, channels: [String]? = nil) {
        self.categories = categories
        self.subTypes = subTypes
        self.channels = channels
    }
}

public struct WebhookSubscription: Codable, Sendable {
    public let _id: String
    public let url: String
    public let description: String?
    public let filter: WebhookFilter
    public let enabled: Bool
    public let lastDeliveryAt: String?
    public let consecutiveFailures: Int
    public let disabledReason: String?
    public let createdAt: String
    public let updatedAt: String
}

public struct CreatedWebhookSubscription: Codable, Sendable {
    public let _id: String
    public let url: String
    public let description: String?
    public let filter: WebhookFilter
    public let enabled: Bool
    public let lastDeliveryAt: String?
    public let consecutiveFailures: Int
    public let disabledReason: String?
    public let createdAt: String
    public let updatedAt: String
    /// HMAC signing secret. Returned ONCE on create.
    public let secret: String
}

public struct CreateWebhookSubscriptionParams: Codable, Sendable {
    public var url: String
    public var description: String?
    public var filter: WebhookFilter

    public init(url: String, description: String? = nil, filter: WebhookFilter) {
        self.url = url
        self.description = description
        self.filter = filter
    }
}

public struct UpdateWebhookSubscriptionParams: Codable, Sendable {
    public var url: String?
    public var description: String?
    public var filter: WebhookFilter?
    public var enabled: Bool?

    public init(
        url: String? = nil,
        description: String? = nil,
        filter: WebhookFilter? = nil,
        enabled: Bool? = nil
    ) {
        self.url = url
        self.description = description
        self.filter = filter
        self.enabled = enabled
    }
}

public enum WebhookDeliveryStatus: String, Codable, Sendable {
    case pending
    case succeeded
    case failed
    case dead
}

public struct WebhookDelivery: Codable, Sendable {
    public let _id: String
    public let eventId: String
    public let status: WebhookDeliveryStatus
    public let attempts: Int
    public let lastAttemptAt: String?
    public let lastResponseStatus: Int?
    public let lastResponseSnippet: String?
    public let nextRetryAt: String?
    public let createdAt: String
}

public struct WebhookSubscriptionListResponse: Codable, Sendable {
    public let data: [WebhookSubscription]
}

public struct WebhookDeliveryListResponse: Codable, Sendable {
    public let data: [WebhookDelivery]
}

// MARK: - Attribution

public struct AttributionRow: Codable, Sendable {
    public let campaignId: String?
    public let journeyId: String?
    public let partnerId: String?
    public let channel: String?
    public let sends: Int
    public let conversions: Int
    public let spendUsd: Double
    public let conversionRate: Double
    public let costPerConversion: Double?
}

public struct AttributionTotals: Codable, Sendable {
    public let sends: Int
    public let conversions: Int
    public let spendUsd: Double
    public let conversionRate: Double
    public let costPerConversion: Double?
}

public struct AttributionSummary: Codable, Sendable {
    public let totals: AttributionTotals
    public let byCampaign: [AttributionRow]
    public let byPartner: [AttributionRow]
    public let byChannel: [AttributionRow]
}

// MARK: - Access Tokens (Personal Access Tokens)

public struct AccessToken: Codable, Sendable {
    public let _id: String
    public let name: String
    public let tokenPrefix: String
    public let scopes: [String]
    public let lastUsedAt: String?
    public let revokedAt: String?
    public let createdAt: String
}

public struct CreatedAccessToken: Codable, Sendable {
    public let _id: String
    public let name: String
    public let tokenPrefix: String
    public let scopes: [String]
    /// Plaintext token. Returned ONCE on creation. Store immediately — server cannot recover it.
    public let token: String
    public let createdAt: String
}

public struct CreateAccessTokenParams: Codable, Sendable {
    public var name: String
    /// Scopes (`verb:resource`). Wildcard `*` grants everything. Default: `["*"]`.
    public var scopes: [String]?

    public init(name: String, scopes: [String]? = nil) {
        self.name = name
        self.scopes = scopes
    }
}

public struct AccessTokenListResponse: Codable, Sendable {
    public let data: [AccessToken]
}

// MARK: - Marketing event stream

public enum EventCategory: String, Codable, Sendable {
    case delivery
    case engagement
    case conversion
    case spend
    case policy
    case partner
    case system
}

public struct Event: Codable, Sendable {
    public let id: String
    public let category: EventCategory
    public let subType: String
    public let channel: String?
    public let externalUserId: String?
    public let campaignId: String?
    public let journeyId: String?
    public let enrollmentId: String?
    public let nodeId: String?
    public let partnerId: String?
    public let policyVersion: String?
    public let spendUsd: Double?
    public let metadata: [String: AnyCodable]?
    public let timestamp: String
}

public struct ListEventsResponse: Codable, Sendable {
    public let data: [Event]
    public let cursor: String?
}

// MARK: - User-behavior events (engage)

public struct UserEvent: Codable {
    public let _id: String
    public let externalUserId: String
    public let eventName: String
    public let properties: [String: AnyCodable]?
    public let timestamp: String
    public let createdAt: String
}

public struct TrackEventParams: Codable {
    public var externalUserId: String
    public var eventName: String
    public var properties: [String: AnyCodable]?
    public var timestamp: String?

    public init(
        externalUserId: String,
        eventName: String,
        properties: [String: AnyCodable]? = nil,
        timestamp: String? = nil
    ) {
        self.externalUserId = externalUserId
        self.eventName = eventName
        self.properties = properties
        self.timestamp = timestamp
    }
}

// MARK: - Partners

public enum PartnerType: String, Codable, Sendable {
    case influencer
    case affiliate
    case agency
    case employee
    case aiAgent = "ai_agent"
}

public enum AttributionMethod: String, Codable, Sendable {
    case utm
    case promoCode = "promo_code"
    case pixel
    case postback
}

public enum TermsType: String, Codable, Sendable {
    case flatFee = "flat_fee"
    case cpm
    case cpc
    case cpa
    case revenueShare = "revenue_share"
    case equity
    case freeProduct = "free_product"
    case hybrid
}

public struct PartnerHandle: Codable, Sendable {
    public var platform: String
    public var handle: String
    public var verified: Bool?

    public init(platform: String, handle: String, verified: Bool? = nil) {
        self.platform = platform
        self.handle = handle
        self.verified = verified
    }
}

public struct PartnerIdentity: Codable, Sendable {
    public var name: String
    public var type: PartnerType
    public var email: String?
    public var handles: [PartnerHandle]?

    public init(name: String, type: PartnerType, email: String? = nil, handles: [PartnerHandle]? = nil) {
        self.name = name
        self.type = type
        self.email = email
        self.handles = handles
    }
}

public struct PartnerTerms: Codable, Sendable {
    public var type: TermsType
    public var rateUsd: Double?
    public var capUsd: Double?
    public var details: [String: AnyCodable]?

    public init(type: TermsType, rateUsd: Double? = nil, capUsd: Double? = nil, details: [String: AnyCodable]? = nil) {
        self.type = type
        self.rateUsd = rateUsd
        self.capUsd = capUsd
        self.details = details
    }
}

public struct PartnerAttribution: Codable, Sendable {
    public var method: AttributionMethod
    public var code: String?
    public var details: [String: AnyCodable]?

    public init(method: AttributionMethod, code: String? = nil, details: [String: AnyCodable]? = nil) {
        self.method = method
        self.code = code
        self.details = details
    }
}

public struct PartnerPaymentRails: Codable, Sendable {
    public var stripeConnectAccountId: String?
    public var manualPayouts: Bool?

    public init(stripeConnectAccountId: String? = nil, manualPayouts: Bool? = nil) {
        self.stripeConnectAccountId = stripeConnectAccountId
        self.manualPayouts = manualPayouts
    }
}

public struct PartnerAudienceProfile: Codable, Sendable {
    public var reach: Int?
    public var demographics: [String: AnyCodable]?
    public var performanceMetrics: [String: AnyCodable]?

    public init(reach: Int? = nil, demographics: [String: AnyCodable]? = nil, performanceMetrics: [String: AnyCodable]? = nil) {
        self.reach = reach
        self.demographics = demographics
        self.performanceMetrics = performanceMetrics
    }
}

public struct Partner: Codable, Sendable {
    public let _id: String
    public let identity: PartnerIdentity
    public let controlledChannelIds: [String]
    public let audienceProfile: PartnerAudienceProfile?
    public let terms: PartnerTerms
    public let attribution: PartnerAttribution
    public let paymentRails: PartnerPaymentRails?
    public let policyIds: [String]
    public let createdAt: String
    public let updatedAt: String
}

public struct CreatePartnerParams: Codable, Sendable {
    public var identity: PartnerIdentity
    public var controlledChannelIds: [String]?
    public var audienceProfile: PartnerAudienceProfile?
    public var terms: PartnerTerms
    public var attribution: PartnerAttribution
    public var paymentRails: PartnerPaymentRails?
    public var policyIds: [String]?

    public init(
        identity: PartnerIdentity,
        terms: PartnerTerms,
        attribution: PartnerAttribution,
        controlledChannelIds: [String]? = nil,
        audienceProfile: PartnerAudienceProfile? = nil,
        paymentRails: PartnerPaymentRails? = nil,
        policyIds: [String]? = nil
    ) {
        self.identity = identity
        self.terms = terms
        self.attribution = attribution
        self.controlledChannelIds = controlledChannelIds
        self.audienceProfile = audienceProfile
        self.paymentRails = paymentRails
        self.policyIds = policyIds
    }
}

public struct UpdatePartnerParams: Codable, Sendable {
    public var identity: PartnerIdentity?
    public var controlledChannelIds: [String]?
    public var audienceProfile: PartnerAudienceProfile?
    public var terms: PartnerTerms?
    public var attribution: PartnerAttribution?
    public var paymentRails: PartnerPaymentRails?
    public var policyIds: [String]?

    public init(
        identity: PartnerIdentity? = nil,
        controlledChannelIds: [String]? = nil,
        audienceProfile: PartnerAudienceProfile? = nil,
        terms: PartnerTerms? = nil,
        attribution: PartnerAttribution? = nil,
        paymentRails: PartnerPaymentRails? = nil,
        policyIds: [String]? = nil
    ) {
        self.identity = identity
        self.controlledChannelIds = controlledChannelIds
        self.audienceProfile = audienceProfile
        self.terms = terms
        self.attribution = attribution
        self.paymentRails = paymentRails
        self.policyIds = policyIds
    }
}

// MARK: - Policies

public enum PolicyScope: String, Codable, Sendable {
    case regulatory
    case channel
    case brand
    case partner
    case operational
}

public enum PolicyRuleType: String, Codable, Sendable {
    case requiredText = "required_text"
    case forbiddenText = "forbidden_text"
    case requiredDisclosure = "required_disclosure"
    case channelConstraint = "channel_constraint"
    case customJson = "custom_json"
}

public enum PolicyRuleSeverity: String, Codable, Sendable {
    case blocking
    case warning
}

public struct PolicyRule: Codable, Sendable {
    public var id: String
    public var type: PolicyRuleType
    public var config: [String: AnyCodable]
    public var severity: PolicyRuleSeverity
    public var message: String

    public init(id: String, type: PolicyRuleType, config: [String: AnyCodable], severity: PolicyRuleSeverity, message: String) {
        self.id = id
        self.type = type
        self.config = config
        self.severity = severity
        self.message = message
    }
}

public struct PolicyAppliesTo: Codable, Sendable {
    public var campaign: Bool?
    public var journey: Bool?
    public var channelTypes: [String]?
    public var partnerIds: [String]?

    public init(campaign: Bool? = nil, journey: Bool? = nil, channelTypes: [String]? = nil, partnerIds: [String]? = nil) {
        self.campaign = campaign
        self.journey = journey
        self.channelTypes = channelTypes
        self.partnerIds = partnerIds
    }
}

public struct Policy: Codable, Sendable {
    public let _id: String
    public let name: String
    public let description: String?
    public let scope: PolicyScope
    public let rules: [PolicyRule]
    public let version: Int
    public let authoredBy: String?
    public let appliesTo: PolicyAppliesTo
    public let active: Bool
    public let createdAt: String
    public let updatedAt: String
}

public struct CreatePolicyParams: Codable, Sendable {
    public var name: String
    public var description: String?
    public var scope: PolicyScope
    public var rules: [PolicyRule]
    public var authoredBy: String?
    public var appliesTo: PolicyAppliesTo?
    public var active: Bool?

    public init(
        name: String,
        scope: PolicyScope,
        rules: [PolicyRule],
        description: String? = nil,
        authoredBy: String? = nil,
        appliesTo: PolicyAppliesTo? = nil,
        active: Bool? = nil
    ) {
        self.name = name
        self.scope = scope
        self.rules = rules
        self.description = description
        self.authoredBy = authoredBy
        self.appliesTo = appliesTo
        self.active = active
    }
}

public struct UpdatePolicyParams: Codable, Sendable {
    public var name: String?
    public var description: String?
    public var scope: PolicyScope?
    public var rules: [PolicyRule]?
    public var appliesTo: PolicyAppliesTo?
    public var active: Bool?

    public init(
        name: String? = nil,
        description: String? = nil,
        scope: PolicyScope? = nil,
        rules: [PolicyRule]? = nil,
        appliesTo: PolicyAppliesTo? = nil,
        active: Bool? = nil
    ) {
        self.name = name
        self.description = description
        self.scope = scope
        self.rules = rules
        self.appliesTo = appliesTo
        self.active = active
    }
}

public struct PolicyViolation: Codable, Sendable {
    public let policyId: String
    public let policyName: String
    public let ruleId: String
    public let severity: PolicyRuleSeverity
    public let message: String
}

public struct SubmitForApprovalResponse: Codable, Sendable {
    public let policyState: PolicyState
    public let violations: [PolicyViolation]
}

public enum PolicyLibraryPack: String, Codable, Sendable {
    case regulatory
    case channel
    case all
}

public struct PolicyLibraryEntry: Codable, Sendable {
    public let id: String
    public let pack: String
    public let name: String
    public let description: String?
    public let scope: PolicyScope
    public let ruleCount: Int
    public let appliesTo: PolicyAppliesTo
}

public struct PolicyLibraryListResponse: Codable, Sendable {
    public let data: [PolicyLibraryEntry]
}

public struct InstallPolicyLibraryParams: Codable, Sendable {
    public var ids: [String]?
    public var pack: PolicyLibraryPack?

    public init(ids: [String]? = nil, pack: PolicyLibraryPack? = nil) {
        self.ids = ids
        self.pack = pack
    }
}

public struct InstalledPolicyLibraryEntry: Codable, Sendable {
    public let libraryId: String
    public let policyId: String
    public let name: String
}

public struct SkippedPolicyLibraryEntry: Codable, Sendable {
    public let id: String
    public let reason: String
}

public struct InstallPolicyLibraryResponse: Codable, Sendable {
    public let installed: [InstalledPolicyLibraryEntry]
    public let skipped: [SkippedPolicyLibraryEntry]
}

// MARK: - Messages

public enum MessageType: String, Codable, Sendable {
    case literal
    case template
    case brief
    case aiGenerated = "ai_generated"
}

public struct EmailMessageVariant: Codable, Sendable {
    public var from: String
    public var subject: String
    public var html: String?
    public var text: String?

    public init(from: String, subject: String, html: String? = nil, text: String? = nil) {
        self.from = from
        self.subject = subject
        self.html = html
        self.text = text
    }
}

public struct PushMessageVariant: Codable, Sendable {
    public var title: String
    public var body: String?
    public var imageUrl: String?
    public var data: [String: String]?

    public init(title: String, body: String? = nil, imageUrl: String? = nil, data: [String: String]? = nil) {
        self.title = title
        self.body = body
        self.imageUrl = imageUrl
        self.data = data
    }
}

public struct SocialMessageVariant: Codable, Sendable {
    public var content: String
    public var mediaUrls: [String]?

    public init(content: String, mediaUrls: [String]? = nil) {
        self.content = content
        self.mediaUrls = mediaUrls
    }
}

/// Channel-keyed Message variants. `email` + `push` are typed; each social
/// platform has its own `SocialMessageVariant` for platform-specific copy.
public struct MessageVariants: Codable, Sendable {
    public var email: EmailMessageVariant?
    public var push: PushMessageVariant?
    public var instagram: SocialMessageVariant?
    public var facebook: SocialMessageVariant?
    public var linkedin: SocialMessageVariant?
    public var tiktok: SocialMessageVariant?
    public var twitter: SocialMessageVariant?
    public var pinterest: SocialMessageVariant?
    public var threads: SocialMessageVariant?
    public var youtube: SocialMessageVariant?

    public init(
        email: EmailMessageVariant? = nil,
        push: PushMessageVariant? = nil,
        instagram: SocialMessageVariant? = nil,
        facebook: SocialMessageVariant? = nil,
        linkedin: SocialMessageVariant? = nil,
        tiktok: SocialMessageVariant? = nil,
        twitter: SocialMessageVariant? = nil,
        pinterest: SocialMessageVariant? = nil,
        threads: SocialMessageVariant? = nil,
        youtube: SocialMessageVariant? = nil
    ) {
        self.email = email
        self.push = push
        self.instagram = instagram
        self.facebook = facebook
        self.linkedin = linkedin
        self.tiktok = tiktok
        self.twitter = twitter
        self.pinterest = pinterest
        self.threads = threads
        self.youtube = youtube
    }
}

public let RECHANNEL_SOCIAL_CHANNEL_TYPES: [String] = [
    "instagram", "facebook", "linkedin", "tiktok",
    "twitter", "pinterest", "threads", "youtube",
]

public struct Message: Codable, Sendable {
    public let _id: String
    public let name: String
    public let description: String?
    public let type: MessageType
    public let version: Int
    public let variants: MessageVariants
    public let brief: String?
    public let createdAt: String
    public let updatedAt: String
}

public struct CreateMessageParams: Codable, Sendable {
    public var name: String
    public var description: String?
    public var type: MessageType?
    /// Required for `.literal`/`.template`.
    public var variants: MessageVariants?
    /// Required for `.brief`/`.aiGenerated`.
    public var brief: String?

    public init(
        name: String,
        description: String? = nil,
        type: MessageType? = nil,
        variants: MessageVariants? = nil,
        brief: String? = nil
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.variants = variants
        self.brief = brief
    }
}

public struct UpdateMessageParams: Codable, Sendable {
    public var name: String?
    public var description: String?
    public var type: MessageType?
    public var variants: MessageVariants?
    public var brief: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        type: MessageType? = nil,
        variants: MessageVariants? = nil,
        brief: String? = nil
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.variants = variants
        self.brief = brief
    }
}

// MARK: - Channels

public enum ChannelType: String, Codable, Sendable {
    case email
    case instagram
    case facebook
    case linkedin
    case tiktok
    case twitter
    case pinterest
    case threads
    case youtube
    case push
}

public enum ChannelAuthState: String, Codable, Sendable {
    case active
    case actionRequired = "action_required"
    case refreshing
    case revoked
    case failed
    case pending
}

public enum ChannelHealth: String, Codable, Sendable {
    case healthy
    case degraded
    case unhealthy
}

public struct ChannelCapabilities: Codable, Sendable {
    public let publish: Bool
    public let schedule: Bool
    public let accountInsights: Bool
    public let postInsights: Bool
    public let mediaUpload: Bool
}

public struct ChannelMetadata: Codable, Sendable {
    public let handle: String?
    public let avatarUrl: String?
    public let domain: String?
    public let accountType: String?
    public let appId: String?
}

public struct Channel: Codable, Sendable {
    public let id: String
    public let type: ChannelType
    public let name: String
    public let authState: ChannelAuthState
    public let health: ChannelHealth
    public let capabilities: ChannelCapabilities
    public let metadata: ChannelMetadata
    public let createdAt: String?
    public let updatedAt: String?
}

public struct ListChannelsResponse: Codable, Sendable {
    public let data: [Channel]
}

// MARK: - Audiences

public enum AudienceDefinitionType: String, Codable, Sendable {
    case staticList = "static_list"
    case dynamicSegment = "dynamic_segment"
    case lookalike
    case partnerAudience = "partner_audience"
    case inferred
}

public struct Audience: Codable {
    public let _id: String
    public let name: String
    public let description: String?
    public let definitionType: AudienceDefinitionType
    public let query: String?
    public let addOnEvent: String?
    public let removeOnEvent: String?
    public let lastEvaluatedCount: Int?
    public let lastEvaluatedAt: String?
    public let createdAt: String
    public let updatedAt: String
}

public struct AudienceMember: Codable {
    public let externalUserId: String
    public let addedAt: String
}

public struct CreateAudienceParams: Codable {
    public var name: String
    public var description: String?
    public var definitionType: AudienceDefinitionType?
    public var query: String?
    public var addOnEvent: String?
    public var removeOnEvent: String?
    /// Required when `definitionType` is `.partnerAudience`. References a Partner.
    public var partnerId: String?

    public init(
        name: String,
        description: String? = nil,
        definitionType: AudienceDefinitionType? = nil,
        query: String? = nil,
        addOnEvent: String? = nil,
        removeOnEvent: String? = nil,
        partnerId: String? = nil
    ) {
        self.name = name
        self.description = description
        self.definitionType = definitionType
        self.query = query
        self.addOnEvent = addOnEvent
        self.removeOnEvent = removeOnEvent
        self.partnerId = partnerId
    }
}

public struct UpdateAudienceParams: Codable {
    public var name: String?
    public var description: String?
    public var definitionType: AudienceDefinitionType?
    public var query: String?
    public var addOnEvent: String?
    public var removeOnEvent: String?
    public var partnerId: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        definitionType: AudienceDefinitionType? = nil,
        query: String? = nil,
        addOnEvent: String? = nil,
        removeOnEvent: String? = nil,
        partnerId: String? = nil
    ) {
        self.name = name
        self.description = description
        self.definitionType = definitionType
        self.query = query
        self.addOnEvent = addOnEvent
        self.removeOnEvent = removeOnEvent
        self.partnerId = partnerId
    }
}

// MARK: - Campaigns

public enum CampaignType: String, Codable {
    case oneShot = "one-shot"
    case scheduled
    case recurring
    case eventTriggered = "event-triggered"
}

public enum CampaignStatus: String, Codable {
    case draft, active, paused, completed, archived
}

public enum PolicyState: String, Codable, Sendable {
    case pending
    case approved
    case rejected
    case bypassed
}

public enum DispatchStrategy: String, Codable, Sendable {
    case broadcast
    case goalDirected = "goal_directed"
}

public struct CampaignGoal: Codable, Sendable {
    public var eventName: String
    public var budgetUsd: Double?

    public init(eventName: String, budgetUsd: Double? = nil) {
        self.eventName = eventName
        self.budgetUsd = budgetUsd
    }
}

public enum EventFilterOp: String, Codable, Sendable {
    case eq, ne, gt, gte, lt, lte
    case `in`, not_in, exists, not_exists
    case contains, not_contains
}

public struct EventPropertyCondition: Codable, Sendable {
    public var path: String
    public var op: EventFilterOp
    public var value: AnyCodable?

    public init(path: String, op: EventFilterOp, value: AnyCodable? = nil) {
        self.path = path; self.op = op; self.value = value
    }
}

/// Bare condition shorthand or compound `{ all?, any? }`. Encoded as the active branch.
public struct EventTriggerFilter: Codable, Sendable {
    public var all: [EventPropertyCondition]?
    public var any: [EventPropertyCondition]?
    public var path: String?
    public var op: EventFilterOp?
    public var value: AnyCodable?

    public init(all: [EventPropertyCondition]? = nil, any: [EventPropertyCondition]? = nil) {
        self.all = all; self.any = any
    }
    public init(_ condition: EventPropertyCondition) {
        self.path = condition.path; self.op = condition.op; self.value = condition.value
    }
}

public struct EventTriggerThrottle: Codable, Sendable {
    public var perUserCooldownSec: Int?
    public var maxPerUser: Int?
    public var windowSec: Int?

    public init(perUserCooldownSec: Int? = nil, maxPerUser: Int? = nil, windowSec: Int? = nil) {
        self.perUserCooldownSec = perUserCooldownSec
        self.maxPerUser = maxPerUser
        self.windowSec = windowSec
    }
}

public struct Campaign: Codable {
    public let _id: String
    public let name: String
    public let description: String?
    public let type: CampaignType
    public let status: CampaignStatus
    public let audienceId: String
    public let messageId: String
    public let channelIds: [String]
    public let policyState: PolicyState
    public let dispatchStrategy: DispatchStrategy
    public let goal: CampaignGoal?
    public let scheduledAt: String?
    public let cronExpression: String?
    public let triggerEventName: String?
    public let triggerDelayMs: Int?
    public let triggerDelaySteps: [Int]?
    public let triggerFilter: EventTriggerFilter?
    public let triggerThrottle: EventTriggerThrottle?
    public let lastExecutedAt: String?
    public let totalSent: Int
    public let totalFailed: Int
    public let createdAt: String
    public let updatedAt: String
}

public enum CampaignExecutionStatus: String, Codable {
    case pending, running, completed, failed
}

public struct CampaignExecution: Codable {
    public let _id: String
    public let campaignId: String
    public let status: CampaignExecutionStatus
    public let startedAt: String?
    public let completedAt: String?
    public let profilesMatched: Int
    public let messagesSent: Int
    public let messagesFailed: Int
    public let messagesSkipped: Int
    public let errorMessage: String?
    public let triggeredByExternalUserId: String?
    public let createdAt: String
}

public struct CreateCampaignParams: Codable {
    public var name: String
    public var description: String?
    public var type: CampaignType
    public var audienceId: String
    public var messageId: String
    public var channelIds: [String]
    public var scheduledAt: String?
    public var cronExpression: String?
    public var triggerEventName: String?
    public var triggerDelayMs: Int?
    public var triggerDelaySteps: [Int]?
    public var triggerFilter: EventTriggerFilter?
    public var triggerThrottle: EventTriggerThrottle?
    public var dispatchStrategy: DispatchStrategy?
    public var goal: CampaignGoal?

    public init(
        name: String,
        type: CampaignType,
        audienceId: String,
        messageId: String,
        channelIds: [String],
        description: String? = nil,
        scheduledAt: String? = nil,
        cronExpression: String? = nil,
        triggerEventName: String? = nil,
        triggerDelayMs: Int? = nil,
        triggerDelaySteps: [Int]? = nil,
        triggerFilter: EventTriggerFilter? = nil,
        triggerThrottle: EventTriggerThrottle? = nil,
        dispatchStrategy: DispatchStrategy? = nil,
        goal: CampaignGoal? = nil
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.audienceId = audienceId
        self.messageId = messageId
        self.channelIds = channelIds
        self.scheduledAt = scheduledAt
        self.cronExpression = cronExpression
        self.triggerEventName = triggerEventName
        self.triggerDelayMs = triggerDelayMs
        self.triggerDelaySteps = triggerDelaySteps
        self.triggerFilter = triggerFilter
        self.triggerThrottle = triggerThrottle
        self.dispatchStrategy = dispatchStrategy
        self.goal = goal
    }
}

public struct UpdateCampaignParams: Codable {
    public var name: String?
    public var description: String?
    public var audienceId: String?
    public var messageId: String?
    public var channelIds: [String]?
    public var cronExpression: String?
    public var triggerEventName: String?
    public var triggerDelayMs: Int?
    public var triggerDelaySteps: [Int]?
    public var triggerFilter: EventTriggerFilter?
    public var triggerThrottle: EventTriggerThrottle?
    public var dispatchStrategy: DispatchStrategy?
    public var goal: CampaignGoal?

    public init(
        name: String? = nil,
        description: String? = nil,
        audienceId: String? = nil,
        messageId: String? = nil,
        channelIds: [String]? = nil,
        cronExpression: String? = nil,
        triggerEventName: String? = nil,
        triggerDelayMs: Int? = nil,
        triggerDelaySteps: [Int]? = nil,
        triggerFilter: EventTriggerFilter? = nil,
        triggerThrottle: EventTriggerThrottle? = nil,
        dispatchStrategy: DispatchStrategy? = nil,
        goal: CampaignGoal? = nil
    ) {
        self.name = name
        self.description = description
        self.audienceId = audienceId
        self.messageId = messageId
        self.channelIds = channelIds
        self.cronExpression = cronExpression
        self.triggerEventName = triggerEventName
        self.triggerDelayMs = triggerDelayMs
        self.triggerDelaySteps = triggerDelaySteps
        self.triggerFilter = triggerFilter
        self.triggerThrottle = triggerThrottle
        self.dispatchStrategy = dispatchStrategy
        self.goal = goal
    }
}

// MARK: - Journeys

public enum JourneyStatus: String, Codable {
    case draft, active, paused, completed, archived
}

public enum JourneyEntryType: String, Codable {
    case event, audience, api
}

public enum JourneyNodeType: String, Codable {
    case entry, delay
    case send_push, send_email, send_message
    case decision_split
    case add_to_audience, remove_from_audience
    case watch_website, exit
}

/// Reference-based send node config — preferred over inline `send_push` / `send_email`.
public struct SendMessageNodeConfig: Codable, Sendable {
    public var messageId: String
    public var channelTypes: [String]?

    public init(messageId: String, channelTypes: [String]? = nil) {
        self.messageId = messageId
        self.channelTypes = channelTypes
    }
}

public enum EnrollmentStatus: String, Codable {
    case active, completed, exited, failed
}

public struct JourneyNode: Codable {
    public var nodeId: String
    public var type: JourneyNodeType
    public var label: String?
    public var config: [String: AnyCodable]
    public var nextNodeId: String?

    public init(
        nodeId: String,
        type: JourneyNodeType,
        config: [String: AnyCodable],
        label: String? = nil,
        nextNodeId: String? = nil
    ) {
        self.nodeId = nodeId
        self.type = type
        self.label = label
        self.config = config
        self.nextNodeId = nextNodeId
    }
}

public struct Journey: Codable {
    public let _id: String
    public let name: String
    public let description: String?
    public let status: JourneyStatus
    public let entryType: JourneyEntryType
    public let triggerEventName: String?
    public let triggerDelayMs: Int?
    public let triggerFilter: EventTriggerFilter?
    public let triggerThrottle: EventTriggerThrottle?
    public let entryAudienceId: String?
    public let policyState: PolicyState
    public let nodes: [JourneyNode]
    public let totalEnrolled: Int
    public let totalCompleted: Int
    public let totalMessagesSent: Int
    public let createdAt: String
    public let updatedAt: String
}

public struct NodeVisit: Codable {
    public let nodeId: String
    public let enteredAt: String
    public let exitedAt: String?
}

public struct JourneyEnrollment: Codable {
    public let _id: String
    public let journeyId: String
    public let externalUserId: String
    public let status: EnrollmentStatus
    public let currentNodeId: String
    public let history: [NodeVisit]
    public let completedAt: String?
    public let createdAt: String
    public let updatedAt: String
}

public struct CreateJourneyParams: Codable {
    public var name: String
    public var description: String?
    public var entryType: JourneyEntryType
    public var triggerEventName: String?
    public var triggerDelayMs: Int?
    public var triggerFilter: EventTriggerFilter?
    public var triggerThrottle: EventTriggerThrottle?
    public var entryAudienceId: String?
    public var nodes: [JourneyNode]

    public init(
        name: String,
        entryType: JourneyEntryType,
        nodes: [JourneyNode],
        description: String? = nil,
        triggerEventName: String? = nil,
        triggerDelayMs: Int? = nil,
        triggerFilter: EventTriggerFilter? = nil,
        triggerThrottle: EventTriggerThrottle? = nil,
        entryAudienceId: String? = nil
    ) {
        self.name = name
        self.description = description
        self.entryType = entryType
        self.triggerEventName = triggerEventName
        self.triggerDelayMs = triggerDelayMs
        self.triggerFilter = triggerFilter
        self.triggerThrottle = triggerThrottle
        self.entryAudienceId = entryAudienceId
        self.nodes = nodes
    }
}

public struct UpdateJourneyParams: Codable {
    public var name: String?
    public var description: String?
    public var nodes: [JourneyNode]?
    public var triggerEventName: String?
    public var triggerDelayMs: Int?
    public var triggerFilter: EventTriggerFilter?
    public var triggerThrottle: EventTriggerThrottle?

    public init(
        name: String? = nil,
        description: String? = nil,
        nodes: [JourneyNode]? = nil,
        triggerEventName: String? = nil,
        triggerDelayMs: Int? = nil,
        triggerFilter: EventTriggerFilter? = nil,
        triggerThrottle: EventTriggerThrottle? = nil
    ) {
        self.name = name
        self.description = description
        self.nodes = nodes
        self.triggerEventName = triggerEventName
        self.triggerDelayMs = triggerDelayMs
        self.triggerFilter = triggerFilter
        self.triggerThrottle = triggerThrottle
    }
}

// MARK: - Push

public struct PushNotification: Codable {
    public let _id: String
    public let externalUserId: String
    public let title: String?
    public let body: String?
    public let imageUrl: String?
    public let data: [String: String]?
    public let status: String
    public let createdAt: String
}

public struct SendPushParams: Codable {
    public var externalId: String
    public var title: String?
    public var body: String?
    public var imageUrl: String?
    public var data: [String: String]?

    public init(
        externalId: String,
        title: String? = nil,
        body: String? = nil,
        imageUrl: String? = nil,
        data: [String: String]? = nil
    ) {
        self.externalId = externalId
        self.title = title
        self.body = body
        self.imageUrl = imageUrl
        self.data = data
    }
}

public struct SendRawPushParams: Codable {
    public var deviceToken: String
    public var platform: DevicePlatform
    public var title: String?
    public var body: String?
    public var imageUrl: String?
    public var data: [String: String]?

    public init(
        deviceToken: String,
        platform: DevicePlatform,
        title: String? = nil,
        body: String? = nil,
        imageUrl: String? = nil,
        data: [String: String]? = nil
    ) {
        self.deviceToken = deviceToken
        self.platform = platform
        self.title = title
        self.body = body
        self.imageUrl = imageUrl
        self.data = data
    }
}

public struct PushConfig: Codable {
    public var projectId: String
    public var clientEmail: String
    public var privateKey: String

    public init(projectId: String, clientEmail: String, privateKey: String) {
        self.projectId = projectId
        self.clientEmail = clientEmail
        self.privateKey = privateKey
    }
}

public struct FrequencyCap: Codable {
    public var maxMessages: Int
    public var windowSeconds: Int
    public var channels: [String]?

    public init(maxMessages: Int, windowSeconds: Int, channels: [String]? = nil) {
        self.maxMessages = maxMessages
        self.windowSeconds = windowSeconds
        self.channels = channels
    }
}

public struct QuietHours: Codable {
    public var enabled: Bool
    public var startTime: String
    public var endTime: String
    public var defaultTimezone: String?

    public init(enabled: Bool, startTime: String, endTime: String, defaultTimezone: String? = nil) {
        self.enabled = enabled
        self.startTime = startTime
        self.endTime = endTime
        self.defaultTimezone = defaultTimezone
    }
}

// MARK: - Social

public enum IntegrationStatus: String, Codable {
    case active, expired, revoked, error
    case actionRequired = "action_required"
    case refreshing
    case failed
    case pendingAuth = "pending_auth"
}

public enum PostStatus: String, Codable {
    case draft, scheduled, publishing, published, failed
}

public struct IntegrationCapabilities: Codable {
    // Current API fields
    public let publish: Bool?
    public let schedule: Bool?
    public let accountInsights: Bool?
    public let postInsights: Bool?
    public let mediaUpload: Bool?
    public let helperResources: [String]?

    // Legacy field aliases for backward compat
    public var canPublish: Bool? { publish }
    public var canSchedule: Bool? { schedule }
    public var canFetchInsights: Bool? { accountInsights }
}

public struct SocialIntegration: Codable {
    public let _id: String
    public let providerKey: String
    public let category: String
    public let providerAccountId: String?
    public let accountType: String?
    public let displayName: String?
    public let handle: String?
    public let avatarUrl: String?
    public let status: IntegrationStatus
    public let statusReason: String?
    public let tokenExpiresAt: String?
    public let scopes: [String]
    public let connectedAt: String?
    public let lastSyncedAt: String?
    public let lastRefreshedAt: String?
    public let capabilities: IntegrationCapabilities?
    public let metadata: [String: AnyCodable]?
}

public struct CandidateAccount: Codable {
    public let providerAccountId: String
    public let displayName: String?
    public let handle: String?
    public let avatarUrl: String?
    public let accountType: String?
}

public struct SkipAuthSessionResult: Codable {
    public let integrationId: String
    public let status: IntegrationStatus
    public let sessionId: String
    public let authorizationUrl: String
}

public struct AuthSession: Codable {
    public let _id: String
    public let provider: String
    public let mode: AuthSessionMode
    public let status: AuthSessionStatus
    public let authorizationUrl: String
    public let candidateAccounts: [CandidateAccount]?
    /// Integration IDs resolved after completion. API returns as `integrations`.
    public let resolvedIntegrationIds: [String]?
    public let failureReason: String?
    public let expiresAt: String

    private enum CodingKeys: String, CodingKey {
        case _id, provider, mode, status, authorizationUrl, candidateAccounts
        case resolvedIntegrationIds = "integrations"
        case failureReason, expiresAt
    }
}

public enum AuthSessionMode: String, Codable {
    case connect, reconnect
}

public enum AuthSessionStatus: String, Codable {
    case pending, authorized
    case selectionRequired = "selection_required"
    case completed, expired, failed
}

public struct SocialPost: Codable {
    public let _id: String
    public let integrationId: String
    public let providerKey: String
    public let text: String
    public let mediaAssetIds: [String]
    public let scheduledAt: String?
    public let publishedAt: String?
    public let platformPostId: String?
    public let status: PostStatus
    public let lastError: [String: AnyCodable]?
    public let createdAt: String
    public let updatedAt: String
}

public struct SocialProvider: Codable {
    public let key: String
    public let displayName: String
    public let category: String?
    public let status: String?
    public let supportsMultipleAccountSelection: Bool?
    public let supportsReconnect: Bool?
    public let supportsTokenRefresh: Bool?
    public let capabilities: IntegrationCapabilities
    public let supportedAccountTypes: [String]?

    /// Legacy alias
    public var name: String { displayName }
}

public struct CreateAuthSessionParams: Codable {
    public var provider: String
    public var mode: AuthSessionMode
    public var redirectUri: String
    public var integrationId: String?
    public var requestedAccountType: String?

    public init(
        provider: String,
        mode: AuthSessionMode,
        redirectUri: String,
        integrationId: String? = nil,
        requestedAccountType: String? = nil
    ) {
        self.provider = provider
        self.mode = mode
        self.redirectUri = redirectUri
        self.integrationId = integrationId
        self.requestedAccountType = requestedAccountType
    }
}

public struct SelectAccountsParams: Codable {
    public var providerAccountIds: [String]

    public init(providerAccountIds: [String]) {
        self.providerAccountIds = providerAccountIds
    }
}

public struct UpdateIntegrationParams: Codable {
    public var displayName: String?
    public var avatarUrl: String?
    public var settings: [String: AnyCodable]?

    public init(displayName: String? = nil, avatarUrl: String? = nil, settings: [String: AnyCodable]? = nil) {
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        self.settings = settings
    }
}

public struct CreatePostParams: Codable {
    public var integrationId: String
    public var text: String
    public var mediaAssetIds: [String]?
    public var scheduledAt: String?

    public init(integrationId: String, text: String, mediaAssetIds: [String]? = nil, scheduledAt: String? = nil) {
        self.integrationId = integrationId
        self.text = text
        self.mediaAssetIds = mediaAssetIds
        self.scheduledAt = scheduledAt
    }
}

public struct PublishTestPostRequest: Codable {
    public var integrationId: String?
    public var text: String?

    public init(integrationId: String? = nil, text: String? = nil) {
        self.integrationId = integrationId
        self.text = text
    }
}

public struct PublishTestPostResponse: Codable {
    public let ok: Bool
    public let message: String
    public let integrationId: String
    public let post: SocialPost
}

// MARK: - Social Insights (Advanced Analytics)

public struct InsightMetrics: Codable {
    public let impressions: Int?
    public let reach: Int?
    public let likes: Int?
    public let comments: Int?
    public let shares: Int?
    public let saves: Int?
    public let clicks: Int?
    public let views: Int?
    public let engagementRate: Double?
}

public struct DailyMetrics: Codable {
    public let dailyData: [DailyDataPoint]?
    public let platformBreakdown: [PlatformBreakdown]?

    public struct DailyDataPoint: Codable {
        public let date: String?
        public let postCount: Int?
        public let platforms: [String: Int]?
        public let metrics: InsightMetrics?
    }

    public struct PlatformBreakdown: Codable {
        public let platform: String?
        public let postCount: Int?
        public let impressions: Int?
        public let reach: Int?
        public let likes: Int?
        public let comments: Int?
        public let shares: Int?
        public let saves: Int?
        public let clicks: Int?
        public let views: Int?
        public let engagementRate: Double?
    }
}

public struct FollowerStats: Codable {
    public let accounts: [AccountFollowerInfo]?
    public let stats: [String: [FollowerDataPoint]]?
    public let dateRange: DateRange?
    public let granularity: String?

    public struct AccountFollowerInfo: Codable {
        public let accountId: String?
        public let platform: String?
        public let currentFollowers: Int?
        public let growth: Int?
        public let growthPercentage: Double?
        public let dataPoints: Int?
    }

    public struct FollowerDataPoint: Codable {
        public let date: String?
        public let followers: Int?
    }

    public struct DateRange: Codable {
        public let from: String?
        public let to: String?
    }
}

public struct BestTimeToPost: Codable {
    public let slots: [EngagementSlot]?

    public struct EngagementSlot: Codable {
        public let day_of_week: Int?
        public let hour: Int?
        public let avg_engagement: Double?
        public let post_count: Int?
    }
}

public struct ContentDecay: Codable {
    public let buckets: [DecayBucket]?

    public struct DecayBucket: Codable {
        public let bucket_order: Int?
        public let bucket_label: String?
        public let avg_pct_of_final: Double?
        public let post_count: Int?
    }
}

public struct PostingFrequency: Codable {
    public let frequency: [FrequencyEntry]?

    public struct FrequencyEntry: Codable {
        public let platform: String?
        public let posts_per_week: Double?
        public let avg_engagement_rate: Double?
        public let avg_engagement: Double?
        public let weeks_count: Int?
    }
}

public struct PostTimeline: Codable {
    public let postId: String?
    public let timeline: [TimelineEntry]?

    public struct TimelineEntry: Codable {
        public let date: String?
        public let platform: String?
        public let impressions: Int?
        public let reach: Int?
        public let likes: Int?
        public let comments: Int?
        public let shares: Int?
        public let saves: Int?
        public let clicks: Int?
        public let views: Int?
    }
}

// MARK: - Email

public struct EmailIntegration: Codable {
    public let _id: String
    public let domain: String
    public let status: String
    public let dnsRecords: [DnsRecord]?
    public let createdAt: String
    public let updatedAt: String
}

public struct DnsRecord: Codable {
    public let type: String
    public let name: String
    public let value: String
    public let verified: Bool
}

public struct ConnectEmailParams: Codable {
    public var domain: String
    public var autoDns: Bool?

    public init(domain: String, autoDns: Bool? = nil) {
        self.domain = domain
        self.autoDns = autoDns
    }
}

public struct SendEmailParams: Codable {
    public var from: String
    public var to: [String]
    public var subject: String
    public var html: String?
    public var text: String?
    public var templateId: String?
    public var substitutions: [String: String]?

    public init(
        from: String,
        to: [String],
        subject: String,
        html: String? = nil,
        text: String? = nil,
        templateId: String? = nil,
        substitutions: [String: String]? = nil
    ) {
        self.from = from
        self.to = to
        self.subject = subject
        self.html = html
        self.text = text
        self.templateId = templateId
        self.substitutions = substitutions
    }
}

public struct EmailMessage: Codable {
    public let _id: String
    public let from: String
    public let to: [String]
    public let subject: String
    public let status: String
    public let createdAt: String
}

// MARK: - Analytics

public struct AnalyticsMetrics: Codable {
    public let totals: [String: Int]
    public let byChannel: [String: [String: Int]]
}

public struct CampaignAnalytics: Codable {
    public let campaignId: String
    public let totals: [String: Int]
    public let byChannel: [String: [String: Int]]
}

public struct JourneyAnalytics: Codable {
    public let journeyId: String
    public let totals: [String: Int]
    public let byChannel: [String: [String: Int]]
}

public struct JourneyNodeAnalytics: Codable {
    public let nodeId: String
    public let metrics: [String: Int]
}

public struct UserMessageEvent: Codable {
    public let type: String
    public let channel: String
    public let sourceId: String
    public let sourceType: String
    public let status: String
    public let timestamp: String
}

public struct UserAnalytics: Codable {
    public let data: [UserMessageEvent]
}

// MARK: - Auth

public struct AuthResponse: Codable {
    public let token: String
    public let tenantId: String
}

// MARK: - Me / Memberships

public enum GlobalType: String, Codable, Sendable {
    case god
    case developer
    case support
    case demo
}

public enum MembershipRole: String, Codable, Sendable {
    case owner
}

public struct Membership: Codable, Sendable {
    public let developerId: String
    public let tenantId: String
    public let role: MembershipRole
    public let createdAt: String
    public let updatedAt: String
}

public struct MeResponse: Codable, Sendable {
    public struct Developer: Codable, Sendable {
        public let id: String
        public let email: String
        public let globalType: GlobalType?
    }

    public struct Tenant: Codable, Sendable {
        public let id: String
        public let name: String
    }

    public let developer: Developer
    public let tenant: Tenant?
    public let role: MembershipRole?
}

public struct Workspace: Codable, Sendable {
    public let id: String
    public let name: String
    public let role: MembershipRole
}

public enum TenantPlan: String, Codable, Sendable {
    case basic, pro, enterprise
}

public struct CountResponse: Codable {
    public let count: Int
}

// MARK: - Inbox

public enum InboxCommentPlatform: String, Codable, Sendable {
    case instagram, facebook, twitter, youtube, linkedin, bluesky, reddit
}

public enum InboxDMPlatform: String, Codable, Sendable {
    case instagram, facebook, telegram, bluesky, reddit
}

public struct InboxComment: Codable, Sendable, Identifiable {
    public let _id: String
    public let tenantId: String
    public let brandId: String?
    public let lateAccountId: String
    public let platform: InboxCommentPlatform
    public let postId: String?
    public let platformPostId: String?
    public let platformCommentId: String
    public let parentCommentId: String
    public let isReply: Bool
    public let text: String
    public let authorPlatformId: String?
    public let authorUsername: String?
    public let authorName: String?
    public let authorAvatarUrl: String?
    public let createdAt: String?
    public let readAt: String?
    public let repliedAt: String?

    public var id: String { _id }
}

public struct InboxConversation: Codable, Sendable, Identifiable {
    public let _id: String
    public let tenantId: String
    public let brandId: String?
    public let lateAccountId: String
    public let platform: InboxDMPlatform
    public let externalConversationId: String
    public let platformConversationId: String?
    public let participantId: String?
    public let participantName: String?
    public let participantUsername: String?
    public let participantAvatarUrl: String?
    public let status: String
    public let lastMessageAt: String?
    public let lastMessagePreview: String?
    public let unreadCount: Int

    public var id: String { _id }
}

public struct InboxAttachment: Codable, Sendable {
    public let type: String?
    public let url: String?
}

public struct InboxMessage: Codable, Sendable, Identifiable {
    public let _id: String
    public let tenantId: String
    public let conversationId: String
    public let externalMessageId: String
    public let platformMessageId: String?
    public let direction: String
    public let text: String?
    public let attachments: [InboxAttachment]
    public let senderPlatformId: String?
    public let senderName: String?
    public let senderUsername: String?
    public let senderAvatarUrl: String?
    public let sentAt: String?
    public let isRead: Bool

    public var id: String { _id }
}

struct InboxReplyBody: Encodable, Sendable {
    let message: String
}

struct InboxHideBody: Encodable, Sendable {
    let hidden: Bool
}

// MARK: - Reply Templates

public enum ReplyTemplateScope: String, Codable, Sendable {
    case user
    case team
}

public struct ReplyTemplate: Codable, Sendable, Identifiable {
    public let _id: String
    public let tenantId: String
    public let userId: String?
    public let scope: ReplyTemplateScope
    public let title: String
    public let body: String
    public let tags: [String]
    public let createdAt: String?
    public let updatedAt: String?

    public var id: String { _id }
}

struct CreateReplyTemplateBody: Encodable, Sendable {
    let title: String
    let body: String
    let scope: ReplyTemplateScope
    let tags: [String]?
}

struct UpdateReplyTemplateBody: Encodable, Sendable {
    let title: String?
    let body: String?
    let scope: ReplyTemplateScope?
    let tags: [String]?
}
