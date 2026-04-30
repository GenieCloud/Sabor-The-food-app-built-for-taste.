//  Gio Jones
//  FavoritesView.swift
//  Sabor_Portfolio

import SwiftUI
import SwiftData

struct FavoritesView: View {
    // Fetches only recipes where isFavorite is true
    @Query(filter: #Predicate<Recipe> { $0.isFavorite }, sort: \Recipe.name)
    private var favoriteRecipes: [Recipe]
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("My Favorites")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)

                    if favoriteRecipes.isEmpty {
                        ContentUnavailableView("No Favorites Yet",
                            systemImage: "heart.slash",
                            description: Text("Tap the heart on a recipe to see it here."))
                    } else {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(favoriteRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
