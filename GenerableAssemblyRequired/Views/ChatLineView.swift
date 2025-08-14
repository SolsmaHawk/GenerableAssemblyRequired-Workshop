//
//  ChatLineView.swift
//  ConversationManager
//
//  Created by John Solsma on 8/1/25.
//

import SwiftUI

struct ChatLineView: View {
    let exchange: DisplayableConversationExchange
    let imageURL: URL?
    let hasTools: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let url = imageURL, hasTools {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {
                if let speaker = exchange.speakerName {
                    Text(speaker)
                        .font(.subheadline)
                        .bold()
                }

                if let message = exchange.message {
                    Text(message)
                        .font(.body)
                }
            }
        }
    }
}
