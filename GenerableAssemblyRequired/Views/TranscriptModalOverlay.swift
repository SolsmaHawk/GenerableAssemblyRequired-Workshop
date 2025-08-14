//
//  TranscriptModalOverlay.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import SwiftUI

struct TranscriptModalOverlay: View {
    let datedTranscript: [String: FoundationModelsManager.DatedTranscriptEntry]
    let onDismiss: () -> Void

    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .transition(.opacity)
        VStack {
            Spacer()
            TranscriptModalView(
                datedTranscript: datedTranscript,
                onDismiss: onDismiss
            )
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .padding()
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
