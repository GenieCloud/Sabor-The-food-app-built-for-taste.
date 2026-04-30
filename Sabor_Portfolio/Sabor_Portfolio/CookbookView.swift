//
//  Gio Jones
//  CookbookView.swift
//  Sabor_Portfolio
//

import SwiftUI
import SwiftData
import Kingfisher

struct CookbookView: View {
    @State private var searchText = ""
    @State private var showingCreateSheet = false
    @State private var showFavoritesOnly = false
    
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty || recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            let matchesFavorite = !showFavoritesOnly || recipe.isFavorite
            return matchesSearch && matchesFavorite
        }
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 170), spacing: 15)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Your Sabor Cookbook")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search by cuisine...", text: $searchText)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Toggle(isOn: $showFavoritesOnly) {
                        Label("Show Favorites", systemImage: "heart.fill")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    .tint(.red)

                    VStack {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.top, 20)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .background(
                ZStack {
                    KFImage(URL(string: "https://images.unsplash.com/photo-1466637574441-749b8f19452f?q=80&w=1760&auto=format&fit=crop"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                    
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateSheet = true }) {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateRecipeView()
            }
        }
    }
}

// MARK: - Global Extension for Keyboard Dismissal
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
