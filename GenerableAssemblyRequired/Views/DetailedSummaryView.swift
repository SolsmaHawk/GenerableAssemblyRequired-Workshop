//
//  DetailedSummaryView.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/10/25.
//

import SwiftUI

struct DetailedSummaryView: View {
    let description: String
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        if !description.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "text.book.closed.fill")
                        .imageScale(.medium)
                    Text("Detailed Summary")
                        .font(.headline)
                }
                Group {
                    if let attr = try? AttributedString(markdown: description) {
                        Text(attr)
                    } else {
                        Text(description)
                    }
                }
                .font(.body)
                .lineSpacing(4)
                .textSelection(.enabled)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.accentColor.opacity(0.8),
                                        Color.accentColor.opacity(0.25)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(radius: colorScheme == .dark ? 8 : 4, y: 2)
            )
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 4)
                    .padding(.vertical, 10)
            }
            .padding(.vertical, 6)
        }
    }
}
