//
//  ConversationContentView.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import SwiftUI

struct ConversationContentView: View {
    let conversation: GuidedConversationDisplayable?
    let error: Error?
    let hasTools: Bool
    let speakerToPersonality: [String: GenerablePersonalityDisplayable]
    let conversationVersion: UUID
    let scrollToBottom: (ScrollViewProxy) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach((conversation?.participants ?? []).compactMap { $0 }, id: \.id) { participant in
                            PersonalityCardView(personalityDisplayable: participant, hasTools: hasTools)
                        }
                        Divider()
                        if let conversation = conversation {
                            ForEach(conversation.conversationExchanges.enumerated(), id: \.offset) { index, exchange in
                                let imageURL = speakerToPersonality[exchange.speakerName ?? ""]?.displayImageURL
                                ChatLineView(exchange: exchange, imageURL: imageURL, hasTools: hasTools)
                            }
                        }
                        if let error = error {
                            InlineErrorView(error: error)
                        }

                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding()
                }
                .onChange(of: conversationVersion) { 
                    scrollToBottom(proxy)
                }
            }
        }
    }
}
