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
}
