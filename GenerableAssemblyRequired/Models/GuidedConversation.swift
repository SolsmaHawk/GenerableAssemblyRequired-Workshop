//
//  GuidedConversation.swift
//  ConversationManager
//
//  Created by John Solsma on 7/7/25.
//

import Foundation
import FoundationModels

// MARK: - Model scaffolding students will extend

@Generable
struct GuidedConversation: Codable {
    @Guide(description: "The first participant in the conversation")
    let participantOne: Personality
    @Guide(description: "The second participant in the conversation")
    let participantTwo: Personality

    /*
       ,--.
      ( o_o)   *Welcome to Generable Assembly Required!*
      /)   )
      ^^  ^^
    */
    // TODO(Workshop):
    // Start here — build out your @Generable conversation model.
    // It’s up to you to decide the overall structure:
    // - How many stages or turns the conversation should have.
    // - How many exchanges occur in total.
    //
    // Remember: Generable models are nestable.
    // You can create a separate @Generable type (e.g., ConversationExchange)
    // to represent each turn, and then reference it here as a property
    // or array.
    //
    // You may also want to explore constraints, such as limiting the number
    // of exchanges with `.count(n)` or requiring certain formats for messages.
    //
    // Note: In Generable models, order is important — subsequent content
    // is formed based on the context of previously generated content.
    //
    // Tip: You can visualize your model output by running the project
    // and viewing the transcript. Later in the workshop, you’ll embed
    // this model output in the UI by conforming to the provided protocol.
}


struct DisplayableConversationExchange {
    let speakerName: String?
    let message: String?
}

// MARK: - Protocol students will satisfy

/// Implement this on `GuidedConversation.PartiallyGenerated` to expose only the
/// UI-ready pieces, without leaking the entire generated structure.
///
/// Hints:
/// - `Personality.PartiallyGenerated` exists because `@Generable` fields are optional
///   until the model fills them in.
/// - You likely want to linearize your generated turns into simple
///   `(speakerName, message)` values the UI can render.
protocol GuidedConversationDisplayable {
    /// Exactly two participants. Order matters for your UI (P1, P2).
    var participants: [Personality.PartiallyGenerated?] { get }

    /// Flattened conversation in the order it should be shown.
    /// Tip: Create this from greeting(s) + subsequent array (when present).
    var conversationExchanges: [DisplayableConversationExchange] { get }
}

// MARK: - GuidedConversationDisplayable

extension GuidedConversation.PartiallyGenerated: GuidedConversationDisplayable {

    var participants: [Personality.PartiallyGenerated?] {
        // Already available from the partially generated struct.
        // Optional task: Instead of hardcoding two participants,
        // consider extending your model to support `n` participants.
        // This would require adjusting the @Generable properties in
        // GuidedConversation to handle a list of Personality objects.
        [participantOne, participantTwo]
    }

    var conversationExchanges: [DisplayableConversationExchange] {
        var exchanges: [DisplayableConversationExchange] = []

        // TODO(Workshop):
        // Think about what other properties a guided conversation might need.
        // These could describe different stages or turns in the conversation,
        // and might involve single exchanges or lists of exchanges.
        //
        // Remember: Generable models can be nested, so your properties could
        // reference other @Generable types (like a ConversationExchange struct)
        // to model more complex, structured parts of the conversation.
        //
        // You can also explore constraints, such as limiting the number of turns
        // or specifying formatting rules for certain fields.

        return exchanges
    }
}

/*
 ┌──────────────────────── Generable @Guide Cheat Sheet ──────────────────────────┐
 │ Purpose                                                                        │
 │ • @Guide = schema + intent. It shapes structure AND steers style/content.      │
 │                                                                                │
 │ Writing good descriptions                                                      │
 │ • Be specific about outcome: who, what, format, and brevity.                   │
 │ • Prefer constraints over prose (“2–3 sentences”, “bullet list”, etc.).        │
 │ • Use active voice and concrete nouns (“Provide…”, “List…”, “Use…”).           │
 │                                                                                │
 │ Common patterns                                                                │
 │ • Single value:   @Guide(description: "One-line summary (<= 20 words)")        │
 │ • Bounded list:   @Guide(description: "Turns that build on context", .count(6))│
 │ • Enums:          Generable enums can constrain the model to fixed cases,      │
 │                   ensuring consistent, predictable values.                     │
 │                                                                                │
 │ Nesting & composition                                                          │
 │ • Generable models are nestable. Model complex parts as their own @Generable   │
 │   types and reference them as properties or arrays.                            │
 │                                                                                │
 │ Helpful constraints & hints (examples)                                         │
 │ • Length/shape: “<= 140 chars”, “bullet list”, “no markdown”.                  │
 │ • Count:        .count(n) for predictable arrays.                              │
 │ • Style/tone:   “Plain language”, “Neutral tone”, “No spoilers”.               │
 │ • Continuity:   “Reference previous turn when relevant.”                       │
 │ • Safety rails: “Avoid PII/sensitive topics.”                                  │
 │                                                                                │
 │ Do / Don’t                                                                     │
 │ • DO define what “good” looks like (format, tone, limits).                     │
 │ • DON’T rely on vague prompts (“be creative”).                                 │
 │                                                                                │
 │ Debugging tips                                                                 │
 │ • If outputs drift: tighten description or add constraints.                    │
 │ • If fields are empty: verify optionality on PartiallyGenerated.               │
 └────────────────────────────────────────────────────────────────────────────────┘
*/
