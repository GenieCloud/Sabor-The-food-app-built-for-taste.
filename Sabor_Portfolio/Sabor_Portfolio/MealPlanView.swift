//  Gio Jones
//  MealPlanView.swift
//  Sabor_Portfolio

import SwiftUI
import SwiftData

struct MealPlanView: View {
    // This query looks through your recipes and only grabs the ones in the meal plan
    @Query(filter: #Predicate<Recipe> { $0.isInMealPlan }, sort: \Recipe.name)
    private var mealPlanRecipes: [Recipe]

    var body: some View {
        NavigationStack {
            List {
                if mealPlanRecipes.isEmpty {
                    // ContentUnavailableView shows when the Meal Prep Plan list is empty.
                    ContentUnavailableView(
                        "No Meal Plan Yet",
                        systemImage: "calendar.badge.plus",
                        description: Text("Go to a recipe and toggle 'Add to Meal Prep Plan' to see it here.")
                    )
                } else {
                    ForEach(mealPlanRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            HStack {
                                // Simple list for Meal Prep Plan
                                Text(recipe.name)
                                    .font(.headline)
                                Spacer()
                                Text(recipe.cuisine)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Meal Prep Plan")
        }
    }
}
