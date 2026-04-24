import XCTest
@testable import ReChannelSDK

final class ReChannelTests: XCTestCase {

    func testInitThrowsWithoutCredentials() {
        XCTAssertThrowsError(
            try ReChannel(config: ReChannelConfig(tenantId: "t1"))
        ) { error in
            guard case ReChannelError.missingCredentials = error else {
                return XCTFail("Expected missingCredentials, got \(error)")
            }
        }
    }

    func testInitSucceedsWithToken() {
        XCTAssertNoThrow(
            try ReChannel(config: ReChannelConfig(token: "tok", tenantId: "t1"))
        )
    }

    func testInitSucceedsWithApiKey() {
        XCTAssertNoThrow(
            try ReChannel(config: ReChannelConfig(apiKey: "key", tenantId: "t1"))
        )
    }

    func testAllResourcesExist() throws {
        let rc = try ReChannel(config: ReChannelConfig(token: "tok", tenantId: "t1"))
        // Just verify the properties are accessible (compile-time check + runtime)
        _ = rc.users
        _ = rc.events
        _ = rc.segments
        _ = rc.campaigns
        _ = rc.journeys
        _ = rc.push
        _ = rc.social
        _ = rc.email
        _ = rc.analytics
    }
}

final class AnyCodableTests: XCTestCase {

    func testEncodeDecodeString() throws {
        let original = AnyCodable("hello")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func testEncodeDecodeInt() throws {
        let original = AnyCodable(42)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func testEncodeDecodeBool() throws {
        let original = AnyCodable(true)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func testEncodeDecodeDouble() throws {
        let original = AnyCodable(3.14)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
        XCTAssertEqual(decoded, original)
    }

    func testExpressibleByLiterals() {
        let s: AnyCodable = "test"
        let i: AnyCodable = 123
        let b: AnyCodable = true
        let d: AnyCodable = 1.5
        let n: AnyCodable = nil

        XCTAssertEqual(s, AnyCodable("test"))
        XCTAssertEqual(i, AnyCodable(123))
        XCTAssertEqual(b, AnyCodable(true))
        XCTAssertEqual(d, AnyCodable(1.5))
        XCTAssertEqual(n, AnyCodable(NSNull()))
    }
}

final class ModelsTests: XCTestCase {

    func testUserProfileDecoding() throws {
        let json = """
        {
            "_id": "abc",
            "externalId": "u1",
            "email": "a@b.com",
            "deviceTokens": [],
            "channelPreferences": {"email": true},
            "createdAt": "2024-01-01",
            "updatedAt": "2024-01-01"
        }
        """.data(using: .utf8)!

        let profile = try JSONDecoder().decode(UserProfile.self, from: json)
        XCTAssertEqual(profile._id, "abc")
        XCTAssertEqual(profile.externalId, "u1")
        XCTAssertEqual(profile.email, "a@b.com")
        XCTAssertEqual(profile.channelPreferences.email, true)
    }

    func testCampaignDecoding() throws {
        let json = """
        {
            "_id": "c1",
            "name": "Welcome",
            "type": "one-shot",
            "status": "draft",
            "segmentId": "s1",
            "channels": ["push"],
            "totalSent": 0,
            "totalFailed": 0,
            "createdAt": "2024-01-01",
            "updatedAt": "2024-01-01"
        }
        """.data(using: .utf8)!

        let campaign = try JSONDecoder().decode(Campaign.self, from: json)
        XCTAssertEqual(campaign._id, "c1")
        XCTAssertEqual(campaign.type, .oneShot)
        XCTAssertEqual(campaign.status, .draft)
        XCTAssertEqual(campaign.channels, [.push])
    }

    func testSegmentDecoding() throws {
        let json = """
        {
            "_id": "s1",
            "name": "Active Users",
            "query": "EVENT login COUNT > 3 SINCE 7d",
            "createdAt": "2024-01-01",
            "updatedAt": "2024-01-01"
        }
        """.data(using: .utf8)!

        let segment = try JSONDecoder().decode(Segment.self, from: json)
        XCTAssertEqual(segment.name, "Active Users")
        XCTAssertEqual(segment.query, "EVENT login COUNT > 3 SINCE 7d")
    }

    func testJourneyDecoding() throws {
        let json = """
        {
            "_id": "j1",
            "name": "Onboarding",
            "status": "active",
            "entryType": "event",
            "triggerEventName": "signup",
            "nodes": [],
            "totalEnrolled": 10,
            "totalCompleted": 5,
            "totalMessagesSent": 20,
            "createdAt": "2024-01-01",
            "updatedAt": "2024-01-01"
        }
        """.data(using: .utf8)!

        let journey = try JSONDecoder().decode(Journey.self, from: json)
        XCTAssertEqual(journey.name, "Onboarding")
        XCTAssertEqual(journey.status, .active)
        XCTAssertEqual(journey.entryType, .event)
    }

    func testPaginatedResponseDecoding() throws {
        let json = """
        {
            "data": [{"_id": "s1", "name": "Seg", "createdAt": "2024-01-01", "updatedAt": "2024-01-01"}],
            "hasMore": true,
            "nextCursor": "abc123",
            "total": 50
        }
        """.data(using: .utf8)!

        let page = try JSONDecoder().decode(PaginatedResponse<Segment>.self, from: json)
        XCTAssertEqual(page.data.count, 1)
        XCTAssertTrue(page.hasMore)
        XCTAssertEqual(page.nextCursor, "abc123")
        XCTAssertEqual(page.total, 50)
    }

    func testCreateCampaignParamsEncoding() throws {
        let params = CreateCampaignParams(
            name: "Test",
            type: .scheduled,
            segmentId: "s1",
            channels: [.push, .email],
            pushMessage: PushMessageConfig(title: "Hi")
        )
        let data = try JSONEncoder().encode(params)
        let dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        XCTAssertEqual(dict["name"] as? String, "Test")
        XCTAssertEqual(dict["type"] as? String, "scheduled")
        XCTAssertEqual(dict["segmentId"] as? String, "s1")
    }

    func testAuthSessionStatusDecoding() throws {
        let json = """
        {
            "_id": "as1",
            "provider": "instagram",
            "mode": "connect",
            "status": "selection_required",
            "authorizationUrl": "https://example.com",
            "expiresAt": "2024-01-01"
        }
        """.data(using: .utf8)!

        let session = try JSONDecoder().decode(AuthSession.self, from: json)
        XCTAssertEqual(session.status, .selectionRequired)
        XCTAssertEqual(session.mode, .connect)
    }
}

final class HelpersTests: XCTestCase {

    func testURLEncoding() {
        XCTAssertEqual("user@example.com".urlEncoded, "user@example.com")
        XCTAssertEqual("hello world".urlEncoded, "hello%20world")
    }

    func testPaginationQuery() {
        let empty = paginationQuery(cursor: nil, limit: nil)
        XCTAssertTrue(empty.isEmpty)

        let full = paginationQuery(cursor: "abc", limit: 25)
        XCTAssertEqual(full["cursor"], "abc")
        XCTAssertEqual(full["limit"], "25")
    }
}
