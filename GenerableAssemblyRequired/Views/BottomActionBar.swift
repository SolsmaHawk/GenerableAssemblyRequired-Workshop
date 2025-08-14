//
//  BottomActionBar.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/10/25.
//

import SwiftUI

struct BottomActionBar: View {
    var onShowTranscript: () -> Void
    var body: some View {
        HStack {
            Spacer()
            Button(action: onShowTranscript) {
                Label("Show Transcript", systemImage: "text.quote")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .overlay(Divider(), alignment: .top)
        .shadow(color: .black.opacity(0.06), radius: 8, y: -2)
    }
}
