//
//  WorkshopConstants.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/10/25.
//

import FoundationModels

enum WorkshopConstants {
    static let instructions: String = "Use the image lookup tool to get image urls"
    static let prompt: String = "A conversation between Obi Wan Kenobi and George Washington"
    static let tools: [any Tool] = [ImageLookupTool(), DetailedSummaryTool()]
    static let samplingMode: GenerationOptions.SamplingMode = .greedy
}
