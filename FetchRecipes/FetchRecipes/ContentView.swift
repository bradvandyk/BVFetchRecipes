//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/3/25.
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

struct ContentView: View {
    @State private var recipes: [Recipe] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading recipes...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            } else {
                List(recipes, id: \.uuid) { recipe in
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
                        Text(recipe.cuisine)
                            .font(.subheadline)
                        AsyncImage(url: recipe.photoUrlSmall) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            case .failure(_):
                                Image(systemName: "exclamationmark.triangle.fill")  // Show an error icon
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    recipes = try await fetchRecipes()
                    isLoading = false
                } catch let error {
                    print(error.localizedDescription)
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON response
        let decoder = JSONDecoder()
        let response = try decoder.decode(RecipeResponse.self, from: data)
        
//        let cuisines = response.recipes.map { $0.cuisine }
        return response.recipes
    }
}

#Preview {
    ContentView()
}
