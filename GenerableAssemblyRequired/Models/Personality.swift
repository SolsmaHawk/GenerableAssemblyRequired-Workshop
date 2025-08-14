import Foundation
import FoundationModels

@Generable
struct Personality: Codable, CustomStringConvertible {

    var name: String
    @Guide(description: "Use the ImageLookupTool to fetch a url")
    var imageLookupToolValue: String
    @Guide(description: "Only use the DetailedSummaryTool here")
    var detailedSummary: String
    @Guide(description: "Uniquely identifying traits for this personality.", .count(3...8))
    var traits: [LabledPersonalityTrait]
    @Guide(description: "Uniquely identifying traits for this personality that can be measured on a scale of 1 to 10 with 1 being the least and 10 being the most.", .count(3...8))
    var measuredTraits: [BoundedPersonalityTrait]
    var characterType: CharacterType
    var tone: Tone
    var formality: Formality
    var humorStyle: HumorStyle
    var verbosity: Verbosity
    var languages: [String]
    @Guide(.count(5))
    var favoriteTopics: [String]
    @Guide(.count(2))
    var sampleQuotes: [String]
    @Guide(description: "A unique identifier to distiguish a speaker")
    var conversationIdentifier: Int

    var description: String {
        """
        Name: \(name)
        Character type: \(characterType)
        Tone: \(tone.rawValue)
        Formality: \(formality.rawValue)
        Humor: \(humorStyle.rawValue)
        Verbosity: \(verbosity.rawValue)
        Language: \(languages)
        Favorite Topics: \(favoriteTopics.joined(separator: ", "))
        """
    }

    // MARK: - Supporting Generable Enums

    @Generable
    enum Tone: String, Codable, CaseIterable {
        case warm, professional, sarcastic, neutral, enthusiastic, cynical
    }

    @Generable
    enum Formality: String, Codable, CaseIterable {
        case casual, semiFormal, formal
    }

    @Generable
    enum HumorStyle: String, Codable, CaseIterable {
        case none, dry, witty, slapstick, absurd
    }

    @Generable
    enum Verbosity: String, Codable, CaseIterable {
        case concise, balanced, elaborate
    }
    
    @Generable
    enum CharacterType: String, Codable, Sendable, CaseIterable {
        case original         // An AI-created or user-created persona
        case celebrity        // Real-world celebrities or public figures
        case musician         // Singers, composers, performers
        case screenActor      // TV, film, or stage performer
        case fictional        // From movies, games, books (e.g., Gandalf)
        case historical       // Past figures (e.g., Abraham Lincoln)
        case political        // Politicians, world leaders
        case scientist        // Real or fictional scientists or inventors
        case athlete          // Sports figures
        case mythological     // Gods, legends, folklore (e.g., Thor)
        case influencer       // Social media personalities
        case comedian         // Known for humor or stand-up
        case characterParody  // Over-the-top or comedic imitation of a type
    }
}

@Generable
struct BoundedPersonalityTrait: Codable {
    let traitName: String
    var minValue: Int = 0
    var maxValue: Int = 10
    @Guide(.range(1...10))
    let measuredValue: Int
    @Guide(description: "An emoji that represents this trait")
    let emoji: String?
}

@Generable
struct LabledPersonalityTrait: Codable {
    let traitName: String
    let value: String
    @Guide(description: "An emoji that represents this trait")
    let emoji: String
}

protocol GenerablePersonalityDisplayable {
    var displayImageURL: URL? { get }
    var detailedSummaryDisplayable: String? { get }
    var personalityName: String.PartiallyGenerated? { get }
    var labledTraits: [LabledPersonalityTrait.PartiallyGenerated] { get }
    var boundedTraits: [BoundedPersonalityTrait.PartiallyGenerated] { get }
    var unlabledText: [String]? { get }
    var interestedTopics: [String]? { get }
}

extension Personality.PartiallyGenerated: GenerablePersonalityDisplayable {

    var detailedSummaryDisplayable: String? {
        self.detailedSummary
    }

    var displayImageURL: URL? {
        if let imageUrlString = self.imageLookupToolValue {
            return URL(string: imageUrlString)
        }
        return nil
    }

    var personalityName: String.PartiallyGenerated? {
        self.name
    }
    
    var labledTraits: [LabledPersonalityTrait.PartiallyGenerated] {
        let generatedTraits = self.traits ?? []
        var customTraits: [LabledPersonalityTrait.PartiallyGenerated] = []
        
        // Character type
        if let characterType = self.characterType {
            customTraits.append(
                LabledPersonalityTrait(
                    traitName: "Character Type",
                    value: characterType.rawValue.capitalized,
                    emoji: ""
                ).asPartiallyGenerated()
            )
        }

        // Tone
        if let tone = self.tone {
            customTraits.append(
                LabledPersonalityTrait(
                    traitName: "Tone",
                    value: tone.rawValue.capitalized,
                    emoji: ""
                ).asPartiallyGenerated()
            )
        }

        // Formality
        if let formality = self.formality {
            customTraits.append(
                LabledPersonalityTrait(
                    traitName: "Formality",
                    value: formality.rawValue.capitalized,
                    emoji: ""
                ).asPartiallyGenerated()
            )
        }
        
        // Humor style
        if let humor = self.humorStyle {
            customTraits.append(
                LabledPersonalityTrait(
                    traitName: "Humor Style",
                    value: humor.rawValue.capitalized,
                    emoji: ""
                ).asPartiallyGenerated()
            )
        }
        
        // Verbosity
        if let verbosity = self.verbosity {
            customTraits.append(
                LabledPersonalityTrait(
                    traitName: "Verbosity",
                    value: verbosity.rawValue.capitalized,
                    emoji: ""
                ).asPartiallyGenerated()
            )
        }
        
        // Language
        if let languages = self.languages {
            
            customTraits.append(
                LabledPersonalityTrait(
                    traitName: "Languages",
                    value: languages.count > 0 ? languages.joined(separator: ", ") : "N/A",
                    emoji: ""
                ).asPartiallyGenerated()
            )
        }

        return generatedTraits + customTraits
    }
    
    var boundedTraits: [BoundedPersonalityTrait.PartiallyGenerated] {
        let generatedTraits = self.measuredTraits ?? []
        return generatedTraits
    }
    
    var unlabledText: [String]? {
        self.sampleQuotes
    }
    
    var interestedTopics: [String]? {
        self.favoriteTopics
    }
}
