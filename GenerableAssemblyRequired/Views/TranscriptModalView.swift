//
//  TranscriptModalView.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import SwiftUI

struct TranscriptModalView: View {
    let datedTranscript: [String: FoundationModelsManager.DatedTranscriptEntry]
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Dismiss") {
                    onDismiss()
                }
                .padding()
            }
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(
                            datedTranscript.values.sorted(by: { $0.date < $1.date }),
                            id: \.id
                        ) { entry in
                            ChatBubbleView(entry: entry)
                                .id(entry.id)
                        }
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .onChange(of: datedTranscript.count) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .clipped()
    }
}
