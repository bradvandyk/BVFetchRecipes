//
//  RecipesViewModel.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/7/25.
//

import SwiftUI

@MainActor class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the JSON response
            let decoder = JSONDecoder()
            let response = try decoder.decode(RecipeResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.recipes = response.recipes
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
