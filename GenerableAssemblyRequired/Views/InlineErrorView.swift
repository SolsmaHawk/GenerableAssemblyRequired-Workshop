//
//  ErrorBannerView.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import SwiftUI

struct InlineErrorView: View {
    let error: Error

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
            VStack(alignment: .leading, spacing: 4) {
                Text("An error occurred")
                    .bold()
                    .foregroundColor(.primary)
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.15))
        .cornerRadius(12)
    }
}
