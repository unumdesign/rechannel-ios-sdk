import Foundation

/// Background job status. Mirrors the server's `JobStatus`.
public enum JobStatus: String, Codable, Sendable {
    case waiting
    case active
    case completed
    case failed
    case delayed
    case paused
    case unknown
}

/// A background job. The `id` is opaque — pass it back to `JobsResource.get` /
/// `JobsResource.wait` to check status.
public struct Job: Codable, Sendable {
    public let id: String
    public let type: String
    public let status: JobStatus
    public let progress: Double?
    public let result: AnyCodable?
    public let error: String?
    public let attemptsMade: Int
    public let createdAt: String
    public let startedAt: String?
    public let completedAt: String?
    public let failedAt: String?
}

/// Background jobs resource. Use this to poll the status of async work
/// returned from any endpoint that enqueues a job (publishing, scheduling,
/// campaign sends, analytics syncs).
public struct JobsResource: Sendable {
    let client: HTTPClient

    /// Fetch a job by composite id, optionally long-polling up to `waitSeconds`
    /// (0–60) for the job to reach a terminal state.
    public func get(_ jobId: String, waitSeconds: Int? = nil) async throws -> Job {
        var query: [String: String] = [:]
        if let waitSeconds, waitSeconds > 0 {
            query["wait"] = String(min(60, max(0, waitSeconds)))
        }
        let path = "/v1/jobs/\(jobId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? jobId)"
        return try await client.get(path, query: query.isEmpty ? nil : query)
    }

    /// Poll until the job reaches `completed` or `failed`, or `timeout` elapses.
    /// Uses server-side long-poll under the hood (chunks of 30s).
    public func wait(_ jobId: String, timeout: TimeInterval = 5 * 60) async throws -> Job {
        let deadline = Date().addingTimeInterval(timeout)
        while true {
            let remaining = deadline.timeIntervalSinceNow
            if remaining <= 0 { return try await get(jobId) }
            let waitSeconds = min(30, Int(remaining.rounded(.up)))
            let job = try await get(jobId, waitSeconds: waitSeconds)
            if job.status == .completed || job.status == .failed { return job }
        }
    }
}
