import Foundation

/// Request body for `AiResource.runModel`.
public struct RunFalModelRequest: Codable {
    /// fal model identifier, e.g. `"fal-ai/nano-banana-2"`.
    public let modelId: String
    /// Model-specific input JSON. Shape varies per model — see fal.ai docs.
    public let input: [String: AnyCodable]

    public init(modelId: String, input: [String: AnyCodable]) {
        self.modelId = modelId
        self.input = input
    }
}

/// Raw fal.ai `Result` envelope. Pass-through from the API — re-channel does
/// not normalize across models. `data` is typically the part you want.
public struct RunFalModelResponse: Codable {
    public let data: AnyCodable?
    public let requestId: String?
}

/// AI inference resource. Generic passthrough to fal.ai-hosted models.
///
/// ```swift
/// let result = try await rc.ai.runModel(
///     modelId: "fal-ai/nano-banana-2",
///     input: ["prompt": AnyCodable("a red apple"), "aspect_ratio": AnyCodable("1:1")]
/// )
/// ```
public struct AiResource: Sendable {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    /// Run any fal.ai-hosted model and return the raw result. The model ID is
    /// opaque to re-channel — pass any fal model identifier. The `input` is
    /// the model-specific payload. fal-hosted URLs in the response may expire;
    /// download immediately if durable storage is needed.
    public func runModel(modelId: String, input: [String: AnyCodable]) async throws -> RunFalModelResponse {
        try await client.post(
            "/v1/ai/run-model",
            body: RunFalModelRequest(modelId: modelId, input: input),
        )
    }
}
