//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Brad Van Dyk on 2/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipesViewModel() // Create the ViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading recipes...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            } else {
                List(viewModel.recipes, id: \.uuid) { recipe in
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
                await viewModel.fetchRecipes() // Fetch recipes when the view appears
            }
        }
    }
}

#Preview {
    ContentView()
}
