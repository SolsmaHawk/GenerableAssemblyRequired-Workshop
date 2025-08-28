# 🦉 Generable Assembly Required Workshop  

Welcome to **Generable Assembly Required**, a hands-on workshop exploring Apple’s **Foundation Models Framework (FMF)**.  
In this session, you’ll build, extend, and experiment with **Generable models**, **Guides**, and **Tool-calling** to create dynamic conversations between fictional or historical personalities.  

---

## 📚 Workshop Overview  

This workshop is broken into **two main parts**:  

### Part 1 – Build a `@Generable` Conversation  
- Extend the `GuidedConversation` model to define how participants interact.  
- Add properties, nested Generable types, and Guides to simulate a realistic dialogue.  
- Explore how order, naming, and constraints affect generated output.  
- Update `WorkshopConstants.swift` to experiment with instructions, prompts, and sampling modes.  

📄 See: **[Workshop_Part1_Instructions.pdf](./Workshop_Part1_Instructions.pdf)**  

---

### Part 2 – Tool-Calling with FMF  
- Implement the tools provided (`ImageLookupTool`, `DetailedSummaryTool`).  
- Use tools to fetch information from **Wikipedia**:  
  - Participant images (ImageLookupTool).  
  - Optional detailed summaries (DetailedSummaryTool).  
- Guide the model to call these tools correctly through precise instructions and `@Guide` annotations.  
- Experiment with prompting strategies — tool usage in FMF can be **trial and error**, and refinement is expected.  
- Challenge: combine the two tools into one that returns both images and summaries together.  

📄 See: **[Workshop_Part2_Instructions.pdf](./Workshop_Part2_Instructions.pdf)**  

---

## 🛠 Project Setup  

This repo contains a starter Xcode project preconfigured with:  
- `GuidedConversation.swift` → where you’ll build your schema.  
- `WorkshopConstants.swift` → where you’ll adjust prompts, instructions, and tools.  
- Pre-wired SwiftUI views that display your generated conversations.  
- Tools folder with stub implementations for you to complete.  

**You only need to edit:**  
- `GuidedConversation.swift` → define how the conversation flows.  
- `WorkshopConstants.swift` → adjust instructions, prompts, and sampling mode.  
- `Tools/` → complete the provided tool stubs (`ImageLookupTool`, optionally `DetailedSummaryTool`).  
- (Optional) `Personality.swift` → extend personalities with richer traits if you’d like.  

---

## 🎯 Learning Goals  

By the end of this workshop you’ll:  
- Understand how to define and guide structured generations with `@Generable` and `@Guide`.  
- Learn how to integrate external APIs into FMF using tools.  
- Explore trial-and-error prompting strategies to steer FMF behavior.  
- Build an interactive SwiftUI-driven conversation powered by on-device generative AI.  

---

## 🦉 Notes & Tips  

- Order matters: properties in your `@Generable` schema are generated sequentially.  
- Good Guides make a big difference: be explicit and concrete.  
- FMF can call tools **once** and return results for multiple participants if your arguments/output are designed correctly.  
- Don’t worry if results drift — iteration and refinement are part of the process.  
- Most importantly: **experiment, have fun, and see what you can create!**  

---

## 🚀 Next Steps  

1. Open the Xcode project.  
2. Review the **Part 1 instructions** and begin by extending `GuidedConversation`.  
3. Once you’ve got conversations flowing, move to **Part 2** and implement the tools.  
4. Share your creations with the group — let’s see what wild conversations you can generate!  
