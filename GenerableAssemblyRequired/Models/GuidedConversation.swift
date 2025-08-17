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
    @Guide(description: "The participants in the conversation")
    let participantsInConversation: [Personality]
    @Guide(description: "The first participant greets the other startled by the absurdity of the entire situation")
    let startledGreeting: ConversationExchange
    @Guide(description: "The simulated conversation between the participants. Each entry represents one turn in the conversation", .count(10))
    let guidedConversationExchanges: [ConversationExchange]

    /*
       ,--.
      ( o_o)   *Welcome to Generable Assembly Required! - GenerOwl*
      /)   )
      ^^  ^^
    */
    // TODO(Workshop):
    // 🦉 START HERE — Build out your @Generable conversation model 🦉
    // MARK: ┌─────────────── PART 1 ───────────────┐
    // MARK: │ Generable Model Setup                │
    // MARK: └──────────────────────────────────────┘
    // It’s up to you to decide the overall structure:
    // - How many stages or turns the conversation should have.
    // - How many exchanges occur in total.
    //
    // Remember: Generable models are nestable.
    // You can create a separate @Generable type (e.g., ConversationExchange 😉)
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
    //
    // 🚨 Important: This project is set up so you only need to update or
    // extend the Generable models (like this one) and adjust constants
    // in WorkshopConstants. All of the SwiftUI code is already configured
    // to display `GuidedConversationDisplayable` and
    // `GenerablePersonalityDisplayable`. No need to edit anything else!
    //
    // ✅ Next step (required): Populate the protocol stubs.
    //    - Conform `GuidedConversation.PartiallyGenerated` to
    //      `GuidedConversationDisplayable` and map your generated fields
    //      into the displayable properties.
    // ✅ Optional stretch: If you include richer personality details,
    //    also conform `Personality.PartiallyGenerated` to
    //    `GenerablePersonalityDisplayable` so the UI can render them.
}

@Generable
struct ConversationExchange: Codable {
    @Guide(description: "The name of the personality speaking")
    let speakerName: String
    @Guide(description: "The message being delivered in the conversation")
    let message: String
}

struct DisplayableConversationExchange {
    let speakerName: String?
    let message: String?
}

// Implement on `GuidedConversation.PartiallyGenerated`.
// Map your generated participants and turns into a UI-ready shape.
// The exact mapping depends on your schema.
protocol GuidedConversationDisplayable {
    var participants: [Personality.PartiallyGenerated?] { get }

    /// Flattened conversation in the order it should be shown.
    /// Tip: Build this from whatever stages/turns you modeled.
    var conversationExchanges: [DisplayableConversationExchange] { get }
}

// MARK: - GuidedConversationDisplayable

extension GuidedConversation.PartiallyGenerated: GuidedConversationDisplayable {
    
    // MARK: ┌─────────────── PART 2 ────────────────────┐
    // MARK: │ GuidedConversationDisplayable Conformance │
    // MARK: └───────────────────────────────────────────┘
    //
    // 📝 Your task here is to *map your Generable model schema* into this
    // display protocol. The SwiftUI views in the project are already wired
    // to consume `GuidedConversationDisplayable` — so whatever you return
    // here is what shows up in the UI.
    //
    // In other words:
    // - Take the properties you defined in your `GuidedConversation` model.
    // - Transform them into `DisplayableConversationExchange` values.
    // - Return them in the correct order (order matters for context).
    //
    // Think of this as the bridge between your generated data
    // and the user interface. If nothing is mapped here, nothing will appear.
    //
    var conversationExchanges: [DisplayableConversationExchange] {
        var exchanges: [DisplayableConversationExchange] = []
        
        if let startledGreeting = startledGreeting {
            exchanges.append(
                DisplayableConversationExchange(
                    speakerName: startledGreeting.speakerName,
                    message: startledGreeting.message
                )
            )
        }
        // Example of mapping a single turn:
        // exchanges.append(
        //     DisplayableConversationExchange(
        //         speakerName: greeting.speakerName,
        //         message: greeting.message
        //     )
        // )
        
        // TODO(Workshop): Map your own conversation stages/exchanges here
        // based on the schema you designed in GuidedConversation.
        
        exchanges.append(contentsOf: (guidedConversationExchanges ?? []).compactMap({ conversationExchange in
                .init(speakerName: conversationExchange.speakerName, message: conversationExchange.message)
        }))
        return exchanges
            
    }
    
    // MARK: ┌──────── PART 2 Continued (OPTIONAL) ────┐
    // MARK: │ The More the Merrier                    │
    // MARK: └─────────────────────────────────────────┘

    var participants: [Personality.PartiallyGenerated?] {
        // Optional task: Instead of hardcoding two participants,
        // consider extending your model to support `n` participants.
        // This would require adjusting the @Generable properties in
        // GuidedConversation to handle a list of Personality objects.
        participantsInConversation ?? []
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
