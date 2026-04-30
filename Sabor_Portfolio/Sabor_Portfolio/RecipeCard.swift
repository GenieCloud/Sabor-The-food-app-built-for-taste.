//  Gio Jones
//  RecipeCard.swift
//  Sabor_Portfolio

import SwiftUI
import Kingfisher

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // Logic to display local data if it exists, otherwise use Kingfisher to load the default image
                if let data = recipe.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipped()
                } else {
                    KFImage(URL(string: recipe.imageURL))
                        .placeholder { Rectangle().fill(Color.gray.opacity(0.2)) }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipped()
                }
                
                // Favorite Toggle with Haptic Feedback
                Button(action: {
                    recipe.isFavorite.toggle()
                }) {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(recipe.isFavorite ? .red : .white)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(8)
                // Sensory/Haptic Feedback
                .sensoryFeedback(.impact, trigger: recipe.isFavorite)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name).font(.headline).lineLimit(1)
                Text("\(recipe.prepTime) mins").font(.subheadline).foregroundColor(.secondary)
            }
            .padding(10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4)
    }
}
