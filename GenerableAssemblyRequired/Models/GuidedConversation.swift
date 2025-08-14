//
//  GuidedConversation.swift
//  ConversationManager
//
//  Created by John Solsma on 7/7/25.
//

import Foundation
import FoundationModels

@Generable
struct GuidedConversation: Codable {
    @Guide(description: "The first participant in the conversation")
    let participantOne: Personality
    @Guide(description: "The second participant in the conversation")
    let participantTwo: Personality
    @Guide(description: "Participant 1 greets participant 2")
    let greeting: ConversationExchange
    @Guide(description: "Participant 2 acknowledges and greets participant 1")
    let acknowledgmentAndGreeting: ConversationExchange
    @Guide(description: "The subsequent conversation based on the personality and interests of the participants", .count(8))
    let subsequentConversation: [ConversationExchange]
}

@Generable
struct ConversationExchange: Codable {
    @Guide(description: "The name of speaker delivering the message")
    let speakerName: String
    @Guide(description: "A unique identifier to distiguish a speaker. Should be the same as the speaking personality in the conversation")
    let speakerIdentifier: Int
    @Guide(description: "The next exchange in the conversation")
    let message: String
}

struct DisplayableConversationExchange {
    let speakerName: String?
    let message: String?
}

protocol GuidedConversationDisplayable {
    var participants: [Personality.PartiallyGenerated?] { get }
    var conversationExchanges: [DisplayableConversationExchange] { get }
}

extension GuidedConversation.PartiallyGenerated: GuidedConversationDisplayable {

    var participants: [Personality.PartiallyGenerated?] {
        [participantOne, participantTwo]
    }
    
    var conversationExchanges: [DisplayableConversationExchange] {
        var exchanges: [DisplayableConversationExchange] = []
        if let greeting = greeting {
            exchanges.append(DisplayableConversationExchange(speakerName: greeting.speakerName, message: greeting.message))
        }
        if let acknowledgmentAndGreeting = acknowledgmentAndGreeting {
            exchanges.append(DisplayableConversationExchange(speakerName: acknowledgmentAndGreeting.speakerName, message: acknowledgmentAndGreeting.message))
        }
        if let subsequentConversation = subsequentConversation {
            subsequentConversation.forEach {
                exchanges.append(DisplayableConversationExchange(speakerName: $0.speakerName, message: $0.message))
            }
        }
        return exchanges
    }
    
    
}
