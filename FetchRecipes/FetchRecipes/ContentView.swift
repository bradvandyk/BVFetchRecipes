//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/3/25.
//

import SwiftUI

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
                    HStack {
                        // Left side (cuisine and name)
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        RecipeImageView(photoUrlSmall: recipe.photoUrlSmall, imageId: recipe.uuid)
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
