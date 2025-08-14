//
//  FoundationModelsManager.swift
//  FoundationModelTests
//
//  Created by John Solsma on 6/28/25.
//

import Foundation
import FoundationModels

public final class FoundationModelsManager {

    public enum SessionStatusError: Error {
        case sessionBusy
    }

    public enum ModelAvailabilityError: Error, LocalizedError {
        case appleIntelligenceNotEnabled
        case deviceNotEligible
        case modelNotReady
        case unavailable(reason: String)

        public var errorDescription: String? {
            switch self {
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligence is turned off. Please enable it in Settings."
            case .deviceNotEligible:
                return "This device does not support Apple Intelligence."
            case .modelNotReady:
                return "The model is not ready yet. It may still be downloading or initializing."
            case .unavailable(let reason):
                return "The model is unavailable: \(reason)"
            }
        }
    }

    public private(set) var currentSystemModel: SystemLanguageModel
    private var session: LanguageModelSession
    public private(set) var tools: [any Tool]
    private var instructions: String
    var datedTransriptEntries: [String: DatedTranscriptEntry] = [:]

    public init(instructions: String = "", tools: [any Tool] = []) {
        self.currentSystemModel = .default
        self.instructions = instructions
        self.tools = tools
        self.session = LanguageModelSession(
            model: currentSystemModel,
            tools: tools,
            instructions: instructions
        )

        Task { [weak self] in
            guard let self = self else { return }
            do {
                try self.checkAvailability()
            } catch {
                print("Warning: \(error.localizedDescription)")
            }
        }
    }

    public func updateInstructions(_ newInstructions: String) {
        self.instructions = newInstructions
        self.session = LanguageModelSession(
            model: currentSystemModel,
            tools: tools,
            instructions: newInstructions
        )
    }

    public func refreshAvailability() async throws {
        try checkAvailability()
    }

    public func submit(prompt: String) async throws -> String {
        try checkAvailability()
        try checkIfModelIsBusy()
        return try await session.respond(to: prompt).content
    }

    public func asyncStreamResponse(prompt: String, samplingMode: GenerationOptions.SamplingMode) async throws -> LanguageModelSession.ResponseStream<String> {
        try checkAvailability()
        try checkIfModelIsBusy()
        return session.streamResponse(to: prompt, options: GenerationOptions(sampling: samplingMode))
    }

    public func generate<T: Generable>(prompt: String) async throws -> LanguageModelSession.ResponseStream<T> {
        try checkAvailability()
        try checkIfModelIsBusy()
        return session.streamResponse(to: prompt, generating: T.self, options: GenerationOptions(sampling: .greedy))
    }

    public func generate<T: Generable>(_ type: T.Type, from prompt: String) async throws -> T {
        try checkAvailability()
        try checkIfModelIsBusy()
        return try await session.respond(to: prompt, generating: T.self).content
    }

    public var isResponding: Bool {
        session.isResponding
    }

    public var transcript: Transcript {
        session.transcript
    }
 
    private func checkAvailability() throws {
        switch currentSystemModel.availability {
        case .available:
            return
        case .unavailable(.appleIntelligenceNotEnabled):
            throw ModelAvailabilityError.appleIntelligenceNotEnabled
        case .unavailable(.deviceNotEligible):
            throw ModelAvailabilityError.deviceNotEligible
        case .unavailable(.modelNotReady):
            throw ModelAvailabilityError.modelNotReady
        case .unavailable(let reason):
            throw ModelAvailabilityError.unavailable(reason: "\(reason)")
        }
    }
    
    private func checkIfModelIsBusy() throws {
        guard !isResponding else {
            throw SessionStatusError.sessionBusy
        }
    }
}
