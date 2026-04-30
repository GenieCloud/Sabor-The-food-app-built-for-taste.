//  Gio Jones
//  MainTabView.swift
//  Sabor_Portfolio

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Tab 1: All Recipes
            CookbookView()
                .tabItem {
                    Label("Cookbook", systemImage: "book.fill")
                }

            // Tab 2: Favorites Only
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            // Tab 3: Meal Plan
            MealPlanView() // <--- Add the new view here
                    .tabItem { Label("Meal Plan", systemImage: "calendar") }
        }
        .tint(.black)
    }
}
