//
//  ImageLookupTool.swift
//  ConversationManager
//
//  Created by John Solsma on 7/25/25.
//

import Foundation
import FoundationModels


struct ImageLookupTool: Tool {
    typealias Output = [String]
    
    let name: String = "ImageLookupTool"
    let description: String = "Use this to get the image urls for the conversation participants"

    // MARK: ┌─────────────── PART 3 ────────────────────────┐
    // MARK: │ Tool-Calling Initilization - ImageLookupTool  │
    // MARK: └───────────────────────────────────────────────┘

    func call(arguments: Arguments) async throws -> Output {
        var conversantUrlStrings: [String] = []
        for name in arguments.names {
            let result = try await fetchWikipediaSummary(for: name)
            if let thumbnailImageUrl = result.thumbnail?.source {
                conversantUrlStrings.append(thumbnailImageUrl.absoluteString)
            }
        }
        return conversantUrlStrings
    }
    
    @Generable
    struct Arguments {
        @Guide(description: "The full names of all the participants in the conversation")
        var names: [String]
    }

    private func fetchWikipediaSummary(for title: String) async throws -> WikipediaSummary {
        let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encoded)")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let summary = try await MainActor.run {
            try JSONDecoder().decode(WikipediaSummary.self, from: data)
        }
        return summary
    }

}
