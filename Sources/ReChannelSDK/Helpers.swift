import Foundation

extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? self
    }
}

func paginationQuery(cursor: String?, limit: Int?) -> [String: String] {
    var query: [String: String] = [:]
    if let cursor { query["cursor"] = cursor }
    if let limit { query["limit"] = String(limit) }
    return query
}
