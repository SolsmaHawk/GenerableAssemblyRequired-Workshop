//
//  FoundationModelsManager.Transcript.swift
//  GenerableAssemblyRequired
//
//  Created by John Solsma on 8/4/25.
//

import FoundationModels
import Foundation

extension FoundationModelsManager {

    public var transcriptEntries: [Transcript.Entry] {
        transcript.map({ $0 })
    }

    var loggedTranscriptEntries: [String: DatedTranscriptEntry] {
        transcriptEntries.forEach { transcriptEntry in
            switch transcriptEntry {
            case .instructions(let instructions):
                instructions.segments.map {
                    DatedTranscriptEntry(from: $0, transcriptEntry: transcriptEntry)}.forEach { addOrUpdate(entry: $0, parentEntry: transcriptEntry) }
            case .prompt(let prompt):
                prompt.segments.map {
                    DatedTranscriptEntry(from: $0, transcriptEntry: transcriptEntry)}.forEach { addOrUpdate(entry: $0, parentEntry: transcriptEntry) }
            case .toolCalls(let toolCalls):
                toolCalls.map {
                    DatedTranscriptEntry(generationId: $0.id, entry: $0.description, transcriptEntry: transcriptEntry) }.forEach { addOrUpdate(entry: $0, parentEntry: transcriptEntry) }
                toolCalls.forEach { transcriptEntriesFrom(generatedContent: $0.arguments, for: transcriptEntry).forEach { addOrUpdate(entry: $0, parentEntry: transcriptEntry) } }
            case .toolOutput(let toolOutput):
                toolOutput.segments.map {
                    DatedTranscriptEntry(from: $0, transcriptEntry: transcriptEntry)}.forEach { addOrUpdate(entry: $0, parentEntry: transcriptEntry) }
            case .response(let response):
                response.segments.forEach {
                    switch $0 {
                    case .text(let text):
                        addOrUpdate(entry: DatedTranscriptEntry(generationId: text.id, entry: text.content, transcriptEntry: transcriptEntry), parentEntry: transcriptEntry)
                    case .structure(let structure):
                        dump(structure)
                      transcriptEntriesFrom(generatedContent: structure.content, for: transcriptEntry).forEach { addOrUpdate(entry: $0, parentEntry: transcriptEntry) }
                    @unknown default:
                        break
                    }
                }
            @unknown default:
                break
            }
        }
        return datedTransriptEntries
    }

    func json(string: String) throws -> GuidedConversation {
        try JSONDecoder().decode(GuidedConversation.self, from: Data(string.utf8))
    }

    func allKeys(from jsonString: String) -> [String] {
        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data)
        else { return [] }

        var keys: Set<String> = []

        func walk(_ value: Any) {
            if let dict = value as? [String: Any] {
                for (k, v) in dict {
                    keys.insert(k)
                    walk(v)
                }
            } else if let array = value as? [Any] {
                for v in array {
                    walk(v)
                }
            }
        }

        walk(json)
        return Array(keys)
    }

    func transcriptEntriesFrom(generatedContent: GeneratedContent, for entry: Transcript.Entry) -> [DatedTranscriptEntry] {
        let entries = DatedTranscriptEntry.flattenedEntriesPreservingIDs(
            from: generatedContent,
            transcriptEntry: entry
        )
        return entries
    }

    private func addOrUpdate(entry: DatedTranscriptEntry, parentEntry: Transcript.Entry) {
        if let datedEntry = datedTransriptEntries[entry.id] {
            let updatedEntry = DatedTranscriptEntry(generationId: datedEntry.generationId, entry: entry.entry, date: datedEntry.date, transcriptEntry: parentEntry)
            datedTransriptEntries[entry.id] = updatedEntry
        } else {
            datedTransriptEntries[entry.id] = entry
        }
    }
    
    struct DatedTranscriptEntry: Identifiable {
        var id: String { generationId }
        let generationId: String
        let transcriptEntry: Transcript.Entry
        let entry: String
        let date: Date
        
        init(from segment: Transcript.Segment, date: Date = Date(), transcriptEntry: Transcript.Entry) {
            self.generationId = segment.id
            self.entry = segment.description
            self.date = date
            self.transcriptEntry = transcriptEntry
        }
        
        init(generationId: String, entry: String, date: Date = Date(), transcriptEntry: Transcript.Entry) {
            self.generationId = generationId
            self.entry = entry
            self.date = date
            self.transcriptEntry = transcriptEntry
        }
        
        init(from generatedContent: GeneratedContent, key: String = "", date: Date = Date(), transcriptEntry: Transcript.Entry) {
            self.generationId = generatedContent.id.debugDescription
            self.entry = (key.isEmpty ? "" : (key + ": ")) + generatedContent.debugDescription
            self.date = date
            self.transcriptEntry = transcriptEntry
        }
    }
}

extension Transcript.Entry {
    var typeName: String {
        switch self {
        case .instructions(_):
            return "Instructions"
        case .prompt(_):
            return "Prompt"
        case .toolCalls(_):
            return "Tool Call"
        case .toolOutput(_):
            return "Tool Output"
        case .response(_):
            return "Response"
        @unknown default:
            return "Unknown type"
        }
    }
    
    var emoji: String {
        switch self {
        case .instructions: return "📋"
        case .prompt: return "💬"
        case .toolCalls: return "🛠️"
        case .toolOutput: return "📦"
        case .response: return "🤖"
        @unknown default: return "❓"
        }
    }
}

extension FoundationModelsManager.DatedTranscriptEntry {
    /// Flattens a GeneratedContent tree into "key.path[0]: value" leaves,
    /// preserving each leaf node's GeneratedContent.id.
    static func flattenedEntriesPreservingIDs(from gc: GeneratedContent,
                                              transcriptEntry: Transcript.Entry,
                                              baseDate: Date = .init(),
                                              appendPathToId: Bool = true) -> [FoundationModelsManager.DatedTranscriptEntry] {

        var out: [FoundationModelsManager.DatedTranscriptEntry] = []
        var seen = Set<String>()
        var t: TimeInterval = 0

        func append(path: String, leaf: GeneratedContent) {
            if let s: String = try? leaf.value(String.self) {
                emit(path: path, value: s, leaf: leaf); return
            }
            if let b: Bool = try? leaf.value(Bool.self) {
                emit(path: path, value: String(b), leaf: leaf); return
            }
            if let i: Int = try? leaf.value(Int.self) {
                emit(path: path, value: String(i), leaf: leaf); return
            }
            if let d: Double = try? leaf.value(Double.self) {
                emit(path: path, value: String(d), leaf: leaf); return
            }
            emit(path: path, value: leaf.jsonString, leaf: leaf)
        }

        func emit(path: String, value: String, leaf: GeneratedContent) {
            let line = "\(path): \(value)"
            guard seen.insert(line).inserted else { return }

            let gid = appendPathToId
                ? "\(leaf.id.debugDescription)::\(path)"
                : leaf.id.debugDescription

            out.append(.init(
                generationId: gid,
                entry: line,
                date: baseDate.addingTimeInterval(t),
                transcriptEntry: transcriptEntry
            ))
            t += 0.001
        }

        func walk(_ node: GeneratedContent, path: String) {
            guard let data = node.jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data) else {
                append(path: path.isEmpty ? "$" : path, leaf: node)
                return
            }

            if let dict = json as? [String: Any] {
                for key in dict.keys.sorted() {
                    let childPath = path.isEmpty ? key : "\(path).\(key)"
                    if let child: GeneratedContent = try? node.value(GeneratedContent.self, forProperty: key) {
                        walk(child, path: childPath)
                    } else {
                        emit(path: childPath, value: String(describing: dict[key] ?? "null"), leaf: node)
                    }
                }
                return
            }

            if json is [Any] {
                if let arr: [GeneratedContent] = try? node.value([GeneratedContent].self) {
                    for (i, child) in arr.enumerated() {
                        walk(child, path: "\(path)[\(i)]")
                    }
                } else {
                    append(path: path, leaf: node)
                }
                return
            }
            append(path: path, leaf: node)
        }

        walk(gc, path: "")
        return out
    }
}
