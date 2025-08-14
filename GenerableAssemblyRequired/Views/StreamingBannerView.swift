//
//  StreamingBannerView.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import SwiftUI

struct StreamingBannerView: View {
    enum StreamingState {
        case streaming
        case processing
    }

    let state: StreamingState

    var body: some View {
        HStack {
            Spacer()

            HStack(spacing: 8) {
                ProgressView()
                Text(state == .processing ? "Processing" : "Streaming")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                ProgressView() // invisible dummy to balance layout
                    .opacity(0)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.05))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.blue.opacity(0.15)),
            alignment: .bottom
        )
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(1)
    }
}
