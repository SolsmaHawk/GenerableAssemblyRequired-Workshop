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
    let description: String = "Use this only to provide a detailed summary of the personality"

    func call(arguments: Arguments) async throws -> Output {
        var conversantWikipediaDescriptions: [String] = []
        for name in arguments.names {
            let result = try await fetchWikipediaSummary(for: name)
            conversantWikipediaDescriptions.append(result.extract)
        }
        return conversantWikipediaDescriptions
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
