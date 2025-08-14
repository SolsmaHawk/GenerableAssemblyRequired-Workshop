//
//  WikipediaSummary.swift
//  ConversationManager
//
//  Created by John Solsma on 7/25/25.
//

import Foundation

struct WikipediaSummary: Codable {
    let type: String
    let title: String
    let displayTitle: String
    let namespace: Namespace
    let wikibaseItem: String
    let titles: Titles
    let pageID: Int
    let thumbnail: ImageInfo?
    let originalImage: ImageInfo?
    let lang: String
    let dir: String
    let revision: String
    let tid: String
    let timestamp: String
    let description: String?
    let descriptionSource: String?
    let contentURLs: ContentURLs
    let extract: String
    let extractHTML: String

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case displayTitle = "displaytitle"
        case namespace
        case wikibaseItem = "wikibase_item"
        case titles
        case pageID = "pageid"
        case thumbnail
        case originalImage = "originalimage"
        case lang
        case dir
        case revision
        case tid
        case timestamp
        case description
        case descriptionSource = "description_source"
        case contentURLs = "content_urls"
        case extract
        case extractHTML = "extract_html"
    }
}

struct Namespace: Codable {
    let id: Int
    let text: String
}

struct Titles: Codable {
    let canonical: String
    let normalized: String
    let display: String
}

struct ImageInfo: Codable {
    let source: URL
    let width: Int
    let height: Int
}

struct ContentURLs: Codable {
    let desktop: URLSet
    let mobile: URLSet
}

struct URLSet: Codable {
    let page: URL
    let revisions: URL
    let edit: URL
    let talk: URL
}
