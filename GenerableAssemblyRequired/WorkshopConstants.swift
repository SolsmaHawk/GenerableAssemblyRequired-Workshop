//
//  WorkshopConstants.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/10/25.
//

import FoundationModels


/*
   ,--.
  ( ^o^)  *Get creative!*
  /)   )
  ^^  ^^
*/

enum WorkshopConstants {
    // Instructions are passed into the model alongside your prompt.
    // They act as high-level guidance for how the model should behave
    // and how it might use available tools.
    // Experiment by refining these to see how small changes affect output.
    static let instructions: String = "Use the image lookup tool to get image urls. Groot should only every reply with `I am Groot`"
    
    // The core prompt that sets the stage for your generated conversation.
    // This is where you define the participants and scenario.
    // Try swapping in different personalities, mixing historical figures,
    // fictional characters, or even contrasting archetypes. Have fun!
    static let prompt: String = "A conversation between Obi Wan Kenobi, George Washington, Groot and Tony Stark"
    
    // Tools extend what the model can do beyond pure text generation.
    // By enabling or disabling tools, you can change what information
    // the model has access to and how it enriches conversations.
    // Experiment with different tool combinations to explore possibilities.
    //
    // ✏️ NOTE: We’ll come back and EDIT this section in second half of the workshop
    // MARK: ┌─────────────── PART 3 ────────────────────┐
    // MARK: │ Tool-Calling Setup                        │
    // MARK: └───────────────────────────────────────────┘
    //
    // 🛠 In this section you’ll start working with tools.
    //
    // • Step 1: Remove the comments around the initialized tools in this array
    //   so they are actually passed to the model.
    // • Step 2: Begin with `ImageLookupTool` — implement this tool first to
    //   practice wiring up tool-calling. It provides image URLs for the
    //   participants in your conversation.
    // • Later, you can explore `DetailedSummaryTool` or add your own tools
    //   to extend functionality.
    //
    // Remember: tools are how you give the model capabilities beyond text
    // generation. Adding and enabling them here changes what the model can do.
    //
    static let tools: [any Tool] = [ImageLookupTool()]
    
    // Sampling mode determines *how* the model generates responses.
    // Greedy is deterministic, while other modes like temperature
    // add variability. Tuning this changes the "feel" of the conversation.
    // Try different modes to balance between consistency and creativity.
    static let samplingMode: GenerationOptions.SamplingMode = .greedy
}

/*
 ┌────────────────────────── Workshop Notes ──────────────────────────┐
 │ • These constants shape *how* your conversation is generated.      │
 │ • Don’t just stick to defaults — experiment with changing them.    │
 │   - Swap in different personalities for unexpected results.        │
 │   - Mix and match tools and sampling modes.                        │
 │ • The Foundation Models Framework is powerful but strict:          │
 │   - Guard rails are in place to keep things safe.                  │
 │   - Outputs may occasionally be unpredictable — that’s normal.     │
 │ • Treat prompting as part of the process: iterate, adjust, refine. │
 │ • Most importantly: HAVE FUN!                                      │
 └────────────────────────────────────────────────────────────────────┘
*/
