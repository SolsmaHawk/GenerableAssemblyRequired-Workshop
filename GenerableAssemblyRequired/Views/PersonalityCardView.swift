//
//  PersonalityCardView.swift
//  ConversationManager
//
//  Created by John Solsma on 8/1/25.
//

import SwiftUI

struct PersonalityCardView: View {
    let personalityDisplayable: GenerablePersonalityDisplayable
    let hasTools: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PersonalityHeaderView(personality: personalityDisplayable, hasTools: hasTools)
            DetailedSummaryView(description: personalityDisplayable.detailedSummaryDisplayable ?? "")
            Divider()
            LabeledTraitsView(traits: personalityDisplayable.labledTraits)
            BoundedTraitsSectionView(traits: personalityDisplayable.boundedTraits)
            FavoriteTopicsView(topics: personalityDisplayable.interestedTopics)
            SampleQuotesView(texts: personalityDisplayable.unlabledText)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4))
        )
    }
    
    private struct PersonalityHeaderView: View {
        let personality: GenerablePersonalityDisplayable
        let hasTools: Bool
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let name = personality.personalityName {
                    Text(name)
                        .font(.headline)
                }
                if let imageUrl = personality.displayImageURL, hasTools {
                    AsyncImage(url: imageUrl)
                        .frame(width: 200, height: 250)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                }
            }
        }
    }
    
    private struct LabeledTraitsView: View {
        let traits: [LabledPersonalityTrait.PartiallyGenerated]
        var body: some View {
            ForEach(Array(traits.enumerated()), id: \.offset) { _, trait in
                HStack {
                    if let emoji = trait.emoji {
                        Text(emoji)
                    }
                    if let traitName = trait.traitName, let traitValue = trait.value {
                        Text("\(traitName): \(traitValue)")
                    }
                }
                .font(.subheadline)
            }
        }
    }
    
    private struct BoundedTraitsSectionView: View {
        let traits: [BoundedPersonalityTrait.PartiallyGenerated]
        var body: some View {
            ForEach(Array(traits.enumerated()), id: \.offset) { _, trait in
                BoundedTraitView(trait: trait)
            }
        }
    }
    
    private struct FavoriteTopicsView: View {
        let topics: [String]?
        var body: some View {
            if let topics, !topics.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🌟 Topics:")
                        .font(.subheadline)
                        .bold()
                    Text(topics.joined(separator: ", "))
                        .font(.caption)
                }
            }
        }
    }
    
    private struct SampleQuotesView: View {
        let texts: [String]?
        var body: some View {
            if let texts, !texts.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("💬 Sample Quotes:")
                        .font(.subheadline)
                        .bold()
                        .padding(.top, 4)
                    
                    ForEach(Array(texts.enumerated()), id: \.offset) { _, txt in
                        Text("“\(txt)”")
                            .italic()
                            .font(.caption)
                    }
                }
            }
        }
    }
}
