//  Gio Jones
//  RecipeDetailView.swift
//  Sabor_Portfolio

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    @Bindable var recipe: Recipe
    @State private var showingDeleteAlert = false
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: Header image logic
                ZStack(alignment: .bottomTrailing) {
                    if let data = recipe.imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .containerRelativeFrame(.horizontal)
                            .frame(height: 350)
                            .clipped()
                    } else {
                        AsyncImage(url: URL(string: recipe.imageURL)) { phase in
                            if let image = phase.image {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Rectangle().fill(Color.black.opacity(0.9))
                                    .overlay(Image(systemName: "fork.knife").foregroundColor(.white.opacity(0.5)).font(.largeTitle))
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 350)
                    }
                    
                    Button(action: {
                        recipe.isFavorite.toggle()
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(recipe.isFavorite ? .red : .white)
                            .padding(12)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20).padding(.bottom, 20)
                    .sensoryFeedback(.impact, trigger: recipe.isFavorite)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    // Title and Time
                    VStack(spacing: 8) {
                        Text(recipe.name).font(.system(size: 28, weight: .bold))
                        Text("\(recipe.prepTime) minutes").font(.subheadline).foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity).padding(.top, 25)
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients").font(.headline)
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient)").font(.body).foregroundColor(.secondary)
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instructions").font(.headline)
                        Text(recipe.instructions).font(.body).foregroundColor(.secondary).lineSpacing(4)
                    }
                    
                    // Meal Prep Toggle
                    VStack(alignment: .leading, spacing: 15) {
                        Divider()
                        Toggle(isOn: $recipe.isInMealPlan) {
                            Text("Add to Meal Prep Plan?")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .tint(.black)
                    }
                    .padding(.vertical, 10)
                    
                    // Delete Button
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Text("Delete Recipe").fontWeight(.bold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding().background(Color.black).cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
        }
        .ignoresSafeArea(edges: .top)
        .alert("Delete Recipe", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(recipe)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(recipe.name)?")
        }
    }
}
