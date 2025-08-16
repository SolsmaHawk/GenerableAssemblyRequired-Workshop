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

    // MARK: ┌─────────────── PART 3 - Continued ────────────────────────┐
    // MARK: │ Tool-Calling Initialization - ImageLookupTool             │
    // MARK: └───────────────────────────────────────────────────────────┘
    //
    // 📝 Workshop Notes:
    // • Continue implementing the `call(arguments:)` function.
    //   - This is where your tool does real work, using the `Arguments` you define
    //     to fetch, compute, or transform data.
    //   - In this example, the tool is meant to look up images for participants.
    // • Also flesh out the `Arguments` struct with the inputs your tool requires.
    //   - Typically, these should be marked with @Guide so the model knows
    //     what values to provide.
    //
    // About the Tool protocol:
    // • Tools define a contract between the model and external functionality.
    // • The protocol requires you to specify:
    //   - Arguments: what the tool accepts (Generable, GeneratedContent, etc.).
    //   - Output: what the tool returns (must be PromptRepresentable).
    //   - Metadata: name + description to tell the model how/when to use it.
    //
    // Output flexibility:
    // • Here, Output = [String], which means we’re returning an array of URLs.
    // • But Output could be any PromptRepresentable type:
    //   - A single String
    //   - A Generable struct (e.g., an ImageResult model)
    //   - A custom Codable object that conforms to PromptRepresentable
    // • This means you can design tools to return structured data
    //   that the model can reason about in subsequent steps.
    //
    // Think of tools as "plugins" the model can call: you define the API surface,
    // the model decides when to use it.
    //
    func call(arguments: Arguments) async throws -> Output {
        var conversantUrlStrings: [String] = []
        // TODO(Workshop): Implement logic here to use your Arguments,
        // call out to fetchWikipediaSummary, extract image URLs,
        // and append them into `conversantUrlStrings`.
        return conversantUrlStrings
    }
    
    @Generable
    struct Arguments {
        // TODO(Workshop): Define what inputs your tool needs.
        // Example: participant names to look up images for.
        // Use @Guide annotations to tell the model exactly what values to provide.
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
