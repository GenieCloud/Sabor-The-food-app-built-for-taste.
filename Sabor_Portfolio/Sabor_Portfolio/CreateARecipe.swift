//  Gio Jones
//  CreateRecipeView.swift
//  Sabor_Portfolio

import SwiftUI
import SwiftData
import PhotosUI

struct CreateRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var cuisine = ""
    @State private var prepTime = 30
    @State private var ingredients = ""
    @State private var instructions = ""
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Image Picker
                Section(header: Text("Recipe Image")) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let data = selectedImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(8)
                        } else {
                            Label("Select a Photo", systemImage: "photo.on.rectangle.angled")
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                }
                
                // MARK: Create A Recipe Info
                Section(header: Text("Recipe Details")) {
                    TextField("What is the recipe name?", text: $name)
                    TextField("Recipe Cuisine (e.g., Italian, Mexican)", text: $cuisine)
                }
                
                Section(header: Text("Preparation Time")) {
                    Stepper(value: $prepTime, in: 5...300, step: 5) {
                        Text("\(prepTime) MINUTES").fontWeight(.bold)
                    }
                }
                
                // Ingredients
                Section(header: Text("Ingredients (One per line)")) {
                    TextEditor(text: $ingredients)
                        .frame(minHeight: 100)
                }
                
                // Instructions
                Section(header: Text("Cooking Instructions")) {
                    TextEditor(text: $instructions)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newRecipe = Recipe(
                            name: name,
                            cuisine: cuisine,
                            prepTime: prepTime,
                            ingredients: ingredients.components(separatedBy: .newlines).filter { !$0.isEmpty },
                            instructions: instructions,
                            imageData: selectedImageData
                        )
                        modelContext.insert(newRecipe)
                        dismiss()
                    }
                    // Validation: Ensures fields aren't empty
                    .disabled(name.isEmpty || cuisine.isEmpty || instructions.isEmpty)
                }
            }
        }
    }
}
