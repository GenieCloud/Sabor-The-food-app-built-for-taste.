//  Gio Jones
//  Recipe.swift
//  Sabor_Portfolio

import Foundation
import SwiftData

@Model
class Recipe {
    var name: String
    var cuisine: String
    var prepTime: Int
    var ingredients: [String]
    var instructions: String
    var isFavorite: Bool
    var isInMealPlan: Bool
    var imageURL: String
    
    // Store the actual image data from the Photo Picker
    @Attribute(.externalStorage) var imageData: Data?

    init(
        name: String,
        cuisine: String,
        prepTime: Int,
        ingredients: [String],
        instructions: String = "",
        isFavorite: Bool = false,
        isInMealPlan: Bool = false,
        imageURL: String = "",
        imageData: Data? = nil
    ) {
        self.name = name
        self.cuisine = cuisine
        self.prepTime = prepTime
        self.ingredients = ingredients
        self.instructions = instructions
        self.isFavorite = isFavorite
        self.isInMealPlan = isInMealPlan
        self.imageData = imageData
        
        if imageURL.isEmpty && imageData == nil {
            self.imageURL = "https://images.unsplash.com/photo-1495521821757-a1efb6729352?q=80&w=1000"
        } else {
            self.imageURL = imageURL
        }
    }
}
