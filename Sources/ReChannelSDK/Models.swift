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

// MARK: - Events

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

// MARK: - Segments

public struct Segment: Codable {
    public let _id: String
    public let name: String
    public let description: String?
    public let query: String?
    public let addOnEvent: String?
    public let removeOnEvent: String?
    public let lastEvaluatedCount: Int?
    public let lastEvaluatedAt: String?
    public let createdAt: String
    public let updatedAt: String
}

public struct SegmentMember: Codable {
    public let externalUserId: String
    public let addedAt: String
}

public struct CreateSegmentParams: Codable {
    public var name: String
    public var description: String?
    public var query: String?
    public var addOnEvent: String?
    public var removeOnEvent: String?

    public init(
        name: String,
        description: String? = nil,
        query: String? = nil,
        addOnEvent: String? = nil,
        removeOnEvent: String? = nil
    ) {
        self.name = name
        self.description = description
        self.query = query
        self.addOnEvent = addOnEvent
        self.removeOnEvent = removeOnEvent
    }
}

public struct UpdateSegmentParams: Codable {
    public var name: String?
    public var description: String?
    public var query: String?
    public var addOnEvent: String?
    public var removeOnEvent: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        query: String? = nil,
        addOnEvent: String? = nil,
        removeOnEvent: String? = nil
    ) {
        self.name = name
        self.description = description
        self.query = query
        self.addOnEvent = addOnEvent
        self.removeOnEvent = removeOnEvent
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

public enum Channel: String, Codable {
    case email, push
}

public struct PushMessageConfig: Codable {
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

public struct EmailMessageConfig: Codable {
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

public struct Campaign: Codable {
    public let _id: String
    public let name: String
    public let description: String?
    public let type: CampaignType
    public let status: CampaignStatus
    public let segmentId: String
    public let channels: [Channel]
    public let pushMessage: PushMessageConfig?
    public let emailMessage: EmailMessageConfig?
    public let scheduledAt: String?
    public let cronExpression: String?
    public let triggerEventName: String?
    public let triggerDelayMs: Int?
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
    public var segmentId: String
    public var channels: [Channel]
    public var pushMessage: PushMessageConfig?
    public var emailMessage: EmailMessageConfig?
    public var scheduledAt: String?
    public var cronExpression: String?
    public var triggerEventName: String?
    public var triggerDelayMs: Int?

    public init(
        name: String,
        type: CampaignType,
        segmentId: String,
        channels: [Channel],
        description: String? = nil,
        pushMessage: PushMessageConfig? = nil,
        emailMessage: EmailMessageConfig? = nil,
        scheduledAt: String? = nil,
        cronExpression: String? = nil,
        triggerEventName: String? = nil,
        triggerDelayMs: Int? = nil
    ) {
        self.name = name
        self.description = description
        self.type = type
        self.segmentId = segmentId
        self.channels = channels
        self.pushMessage = pushMessage
        self.emailMessage = emailMessage
        self.scheduledAt = scheduledAt
        self.cronExpression = cronExpression
        self.triggerEventName = triggerEventName
        self.triggerDelayMs = triggerDelayMs
    }
}

public struct UpdateCampaignParams: Codable {
    public var name: String?
    public var description: String?
    public var segmentId: String?
    public var channels: [Channel]?
    public var pushMessage: PushMessageConfig?
    public var emailMessage: EmailMessageConfig?
    public var cronExpression: String?
    public var triggerEventName: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        segmentId: String? = nil,
        channels: [Channel]? = nil,
        pushMessage: PushMessageConfig? = nil,
        emailMessage: EmailMessageConfig? = nil,
        cronExpression: String? = nil,
        triggerEventName: String? = nil
    ) {
        self.name = name
        self.description = description
        self.segmentId = segmentId
        self.channels = channels
        self.pushMessage = pushMessage
        self.emailMessage = emailMessage
        self.cronExpression = cronExpression
        self.triggerEventName = triggerEventName
    }
}

// MARK: - Journeys

public enum JourneyStatus: String, Codable {
    case draft, active, paused, completed, archived
}

public enum JourneyEntryType: String, Codable {
    case event, segment, api
}

public enum JourneyNodeType: String, Codable {
    case delay, push, email, condition, split, webhook
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
    public let entrySegmentId: String?
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
    public var entrySegmentId: String?
    public var nodes: [JourneyNode]

    public init(
        name: String,
        entryType: JourneyEntryType,
        nodes: [JourneyNode],
        description: String? = nil,
        triggerEventName: String? = nil,
        entrySegmentId: String? = nil
    ) {
        self.name = name
        self.description = description
        self.entryType = entryType
        self.triggerEventName = triggerEventName
        self.entrySegmentId = entrySegmentId
        self.nodes = nodes
    }
}

public struct UpdateJourneyParams: Codable {
    public var name: String?
    public var description: String?
    public var nodes: [JourneyNode]?

    public init(name: String? = nil, description: String? = nil, nodes: [JourneyNode]? = nil) {
        self.name = name
        self.description = description
        self.nodes = nodes
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
}

public enum PostStatus: String, Codable {
    case draft, scheduled, publishing, published, failed
}

public struct IntegrationCapabilities: Codable {
    public let canPublish: Bool?
    public let canSchedule: Bool?
    public let canDelete: Bool?
    public let canFetchInsights: Bool?
    public let supportedMediaTypes: [String]?
}

public struct SocialIntegration: Codable {
    public let _id: String
    public let providerKey: String
    public let category: String
    public let providerAccountId: String?
    public let accountType: String?
    public let displayName: String?
    public let title: String?
    public let handle: String?
    public let avatarUrl: String?
    public let status: IntegrationStatus
    public let tokenExpiresAt: String?
    public let scopes: [String]
    public let lastSyncedAt: String?
    public let lastRefreshedAt: String?
    public let capabilities: IntegrationCapabilities
    public let metadata: [String: AnyCodable]?
    public let lastError: [String: AnyCodable]?
    public let createdAt: String
    public let updatedAt: String
}

public struct CandidateAccount: Codable {
    public let providerAccountId: String
    public let displayName: String?
    public let handle: String?
    public let avatarUrl: String?
    public let accountType: String?
}

public struct AuthSession: Codable {
    public let _id: String
    public let provider: String
    public let mode: AuthSessionMode
    public let status: AuthSessionStatus
    public let authorizationUrl: String
    public let candidateAccounts: [CandidateAccount]?
    public let resolvedIntegrationIds: [String]?
    public let failureReason: String?
    public let expiresAt: String
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
    public let name: String
    public let capabilities: IntegrationCapabilities
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

public struct CountResponse: Codable {
    public let count: Int
}
