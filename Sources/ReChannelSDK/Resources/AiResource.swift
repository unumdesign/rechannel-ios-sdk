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

/// Request body for `AiResource.runClaude`.
public struct RunClaudeRequest: Codable {
    /// User message — the task or question for Claude.
    public let prompt: String
    /// Optional system prompt setting persona / voice / output rules.
    public let system: String?
    /// Optional Claude model ID. Defaults to `claude-opus-4-7` on the server.
    public let model: String?
    /// Max output tokens (default 16,000 server-side).
    public let maxTokens: Int?
    /// Enable adaptive thinking. Default false.
    public let enableThinking: Bool?
    /// Cache the system prompt. Defaults to true when `system` is set.
    public let cacheSystem: Bool?

    public init(
        prompt: String,
        system: String? = nil,
        model: String? = nil,
        maxTokens: Int? = nil,
        enableThinking: Bool? = nil,
        cacheSystem: Bool? = nil,
    ) {
        self.prompt = prompt
        self.system = system
        self.model = model
        self.maxTokens = maxTokens
        self.enableThinking = enableThinking
        self.cacheSystem = cacheSystem
    }
}

public struct RunClaudeResponseUsage: Codable {
    public let inputTokens: Int
    public let outputTokens: Int
    public let cacheCreationInputTokens: Int?
    public let cacheReadInputTokens: Int?
}

public struct RunClaudeResponse: Codable {
    public let text: String
    public let stopReason: String?
    public let usage: RunClaudeResponseUsage
    public let raw: AnyCodable?
}

/// AI inference resource. Two passthroughs:
/// - `runModel(...)` → fal.ai-hosted models (image / video / audio).
/// - `runClaude(...)` → Anthropic Claude completions.
///
/// ```swift
/// let result = try await rc.ai.runModel(
///     modelId: "fal-ai/nano-banana-2",
///     input: ["prompt": AnyCodable("a red apple"), "aspect_ratio": AnyCodable("1:1")]
/// )
///
/// let out = try await rc.ai.runClaude(
///     prompt: "Write a punchy launch tweet for re-channel.",
///     system: "You are a witty growth marketer."
/// )
/// print(out.text)
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

    /// Run a Claude (Anthropic) completion. Generic chat-style passthrough with
    /// adaptive thinking + prompt caching opt-ins.
    public func runClaude(
        prompt: String,
        system: String? = nil,
        model: String? = nil,
        maxTokens: Int? = nil,
        enableThinking: Bool? = nil,
        cacheSystem: Bool? = nil,
    ) async throws -> RunClaudeResponse {
        try await client.post(
            "/v1/ai/run-claude",
            body: RunClaudeRequest(
                prompt: prompt,
                system: system,
                model: model,
                maxTokens: maxTokens,
                enableThinking: enableThinking,
                cacheSystem: cacheSystem,
            ),
        )
    }
}
