import Foundation

/// Base error type for all ReChannel SDK errors.
public enum ReChannelError: Error, LocalizedError {
    case missingCredentials
    case invalidURL(String)
    case authentication(String)
    case notFound(String)
    case validation(String, details: Any?)
    case rateLimited(retryAfter: Int?)
    case api(statusCode: Int, message: String, details: Any?)
    case decoding(Error)
    case network(Error)

    public var errorDescription: String? {
        switch self {
        case .missingCredentials:
            return "Either token or apiKey must be provided"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .authentication(let message):
            return "Authentication failed: \(message)"
        case .notFound(let message):
            return "Not found: \(message)"
        case .validation(let message, _):
            return "Validation error: \(message)"
        case .rateLimited(let retryAfter):
            if let retryAfter {
                return "Rate limited. Retry after \(retryAfter) seconds"
            }
            return "Rate limited"
        case .api(let statusCode, let message, _):
            return "API error (\(statusCode)): \(message)"
        case .decoding(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }

    /// Machine-parseable error code from the response envelope, if present.
    /// Mirrors the server's `ErrorCode` enum (e.g. `TENANT_NOT_SET`,
    /// `RATE_LIMITED`, `IDEMPOTENCY_KEY_REUSED`). Use this to branch agent /
    /// retry logic rather than parsing `errorDescription`.
    public var code: String? {
        switch self {
        case .rateLimited:
            return "RATE_LIMITED"
        case .authentication:
            return "UNAUTHENTICATED"
        case .notFound:
            return "NOT_FOUND"
        case .validation(_, let details), .api(_, _, let details):
            return (details as? [String: Any])?["code"] as? String
        default:
            return nil
        }
    }

    /// HTTP-style status code where applicable, or nil for non-HTTP errors.
    public var statusCode: Int? {
        switch self {
        case .authentication: return 401
        case .notFound: return 404
        case .validation: return 400
        case .rateLimited: return 429
        case .api(let statusCode, _, _): return statusCode
        default: return nil
        }
    }

    /// Whether retrying the request is likely to succeed (per server hint).
    public var retryable: Bool {
        switch self {
        case .rateLimited:
            return true
        case .validation(_, let details), .api(_, _, let details):
            return (details as? [String: Any])?["retryable"] as? Bool ?? false
        default:
            return false
        }
    }
}
