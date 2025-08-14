//
//  StreamingConversationView.swift
//  ConversationManager
//
//  Created by John Solsma on 7/7/25.
//

import SwiftUI
import FoundationModels

// MARK: - Main View

struct StreamingConversationView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var isShowingModal = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if viewModel.isStreaming {
                    StreamingBannerView(
                        state: viewModel.datedTranscript.isEmpty ? .processing : .streaming
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                ConversationContentView(
                    conversation: viewModel.conversation,
                    error: viewModel.error,
                    hasTools: viewModel.sessionHasTools,
                    speakerToPersonality: viewModel.speakerToPersonality,
                    conversationVersion: viewModel.conversationVersion,
                    scrollToBottom: scrollToBottom
                )
            }

            if isShowingModal {
                TranscriptModalOverlay(
                    datedTranscript: viewModel.datedTranscript,
                    onDismiss: {
                        withAnimation {
                            isShowingModal = false
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !isShowingModal && !viewModel.datedTranscript.isEmpty {
                BottomActionBar {
                    withAnimation { isShowingModal = true }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isShowingModal)
        .onAppear {
            Task { await viewModel.startStreaming() }
        }
    }

    func scrollToBottom(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            CATransaction.commit()
        }
    }
}
