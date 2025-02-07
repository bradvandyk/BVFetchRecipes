//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/7/25.
//

import SwiftUI

// Model for a Recipe
struct Recipe: Codable, Identifiable {
    var id = UUID()
    
    let cuisine: String
    let name: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let uuid: String
    let youtubeUrl: URL?
    
    // We map the keys in JSON to our property names using CodingKeys
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case uuid
        case youtubeUrl = "youtube_url"
    }
}

// Root model containing the recipes array
struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
