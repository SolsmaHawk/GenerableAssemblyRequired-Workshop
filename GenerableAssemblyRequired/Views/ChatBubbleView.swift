//
//  ChatBubbleView.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import SwiftUI
import FoundationModels

struct ChatBubbleView: View {
    let entry: FoundationModelsManager.DatedTranscriptEntry

    var isRightAligned: Bool {
        switch entry.transcriptEntry {
        case Transcript.Entry.instructions, Transcript.Entry.prompt, Transcript.Entry.toolCalls:
            return true
        default:
            return false
        }
    }

    var bubbleColor: Color {
        isRightAligned ? .blue.opacity(0.15) : .gray.opacity(0.1)
    }

    var body: some View {
        HStack {
            if isRightAligned { Spacer() }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(entry.transcriptEntry.emoji) \(entry.transcriptEntry.typeName)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.entry)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(bubbleColor)
                .cornerRadius(12)

                Text(entry.date.formatted(date: .abbreviated, time: .standard))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            if !isRightAligned { Spacer() }
        }
        .padding(.top, 4)
    }
}
