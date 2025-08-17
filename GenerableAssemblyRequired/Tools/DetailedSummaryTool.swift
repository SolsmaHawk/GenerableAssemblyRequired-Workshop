//
//  WikipediaLookupTool.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/10/25.
//

import Foundation
import FoundationModels

struct DetailedSummaryTool: Tool {
    typealias Output = [String]
    
    let name: String = "DetailedSummaryTool"
    let description: String = "Use this once"

    // MARK: ┌─────────────── PART 3 - OPTIONAL ─────────────────────────┐
    // MARK: │ Tool-Calling Extension - DetailedSummaryTool              │
    // MARK: └───────────────────────────────────────────────────────────┘
    //
    // 📝 Workshop Notes:
    // • This tool is optional — only implement if you want to go further
    //   with tool-calling after finishing `ImageLookupTool`.
    // • Purpose: Fetch a richer text description for each participant
    //   (using the Wikipedia summary `extract` field).
    // • Notice: The Output here is still `[String]`, but you could choose
    //   to return something more structured if you wanted.
    // • The Arguments struct demonstrates how to guide the model to provide
    //   multiple participant names as input.
    // • Try experimenting with when the model chooses to call this tool
    //   and how its output affects your personality display.
    //
    func call(arguments: Arguments) async throws -> Output {
        var conversantWikipediaDescriptions: [String] = []
        for name in arguments.names {
            let wikipediaSummary = try await fetchWikipediaSummary(for: name)
            conversantWikipediaDescriptions.append(wikipediaSummary.extract)
        }
        return conversantWikipediaDescriptions
    }
    
    @Generable
    struct Arguments {
        @Guide(description: "The names of the participants")
        let names: [String]
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
