//
//  StreamingConversationViewModel.swift
//  ConversationManager
//
//  Created by John Solsma on 7/7/25.
//

import Combine
import Foundation
import SwiftUI
import FoundationModels

extension StreamingConversationView {
    @MainActor
    final class ViewModel: ObservableObject {
        var sessionHasTools: Bool { !modelsManager.tools.isEmpty } 
        @Published private(set) var conversationVersion = UUID()
        @Published var error: Error? = nil
        @Published var isStreaming = false
        @Published var datedTranscript: [String: FoundationModelsManager.DatedTranscriptEntry] = [:]
        @Published var conversation: GuidedConversation.PartiallyGenerated? {
            didSet {
                conversationVersion = UUID()
            }
        }

        private lazy var modelsManager = FoundationModelsManager(instructions: WorkshopConstants.instructions,
                                                                 tools: WorkshopConstants.tools)
        
        var speakerToPersonality: [String: GenerablePersonalityDisplayable] {
            let pairs: [(String, GenerablePersonalityDisplayable)] = ((conversation)?.participants ?? []).compactMap { personality in
                guard let personality = personality,
                      let name = personality.personalityName else {
                    return nil
                }
                return (name, personality)
            }
            return Dictionary(uniqueKeysWithValues: pairs)
        }
        
        func startStreaming() async {
            withAnimation {
                isStreaming = true
            }
            do {
                let stream: LanguageModelSession.ResponseStream<GuidedConversation> =
                try await modelsManager.generate(prompt: WorkshopConstants.prompt,
                                                 generationOptions: .init(sampling: WorkshopConstants.samplingMode))
                
                for try await snapshot in stream {
                    withAnimation(.smooth) {
                        self.conversation = snapshot.content
                        self.datedTranscript = modelsManager.loggedTranscriptEntries
                    }
                }
            } catch let error{
                isStreaming = false
                self.error = error
                print("❌ Error: \(error)")
            }
            withAnimation {
                isStreaming = false
            }
        }
    }
}
