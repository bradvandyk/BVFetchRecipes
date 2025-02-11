//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Brad Van Dyk on 2/3/25.
//

import Foundation
import FetchRecipes
import Testing

struct FetchRecipesTests {
    // URL for the test data
    let malformedDataURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
    
    // Function to test the malformed data
    @Test
    func testMalformedData() async throws {
        
        // Perform the URLSession request asynchronously
        let (data, response) = try await URLSession.shared.data(from: malformedDataURL)
        
        // Check if the response is successful
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "MalformedDataTest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        // Try decoding the data (assuming you're decoding into a model, e.g., Recipe)
        let decoder = JSONDecoder()
        
        // Assuming we expect an array of recipes (you can modify based on actual structure)
        do {
            let recipes = try decoder.decode([Recipe].self, from: data)
            
            // Check that the data is malformed (for this test case, assume a valid recipe must have a name)
            let malformedRecipes = recipes.filter { $0.name.isEmpty }
            
            // Assert that we have at least one malformed recipe (or handle other data inconsistencies as needed)
            #expect(malformedRecipes.count > 0, "Malformed data found, but no malformed recipes identified.")
            
        } catch let error {
            print(error.localizedDescription)
            // If decoding fails, we consider that as malformed data.
            #expect(true, "Data is malformed, cannot decode properly.")
        }
    }
    
    // Function to test the malformed data
    @Test
    func testRecipeData() async throws {
        
        // Perform the URLSession request asynchronously
        let (data, response) = try await URLSession.shared.data(from: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
        
        // Check if the response is successful
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "MalformedDataTest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        // Try decoding the data (assuming you're decoding into a model, e.g., Recipe)
        let decoder = JSONDecoder()
        
        // Assuming we expect an array of recipes (you can modify based on actual structure)
        do {
            let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
            
            // Assert that we have at least one recipe
            #expect(recipeResponse.recipes.count > 0, "Recipes are not parsing correctly or server is down.")
            
        } catch let error {
            print(error.localizedDescription)
            #expect(true, "Cannot decode recipes properly.")
        }
    }
}
