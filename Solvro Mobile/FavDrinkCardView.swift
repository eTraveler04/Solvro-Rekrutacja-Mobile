//
//  FavDrinkCardView.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 19/03/2025.
//

import SwiftUI

struct FavDrinkCardView: View {
    @ObservedObject var favoritesManager = FavoritesManager.shared
    @State private var offset = CGSize.zero
    @State private var currentIndex = 0

    var body: some View {
        let drinks = favoritesManager.favoriteDrinks
        Group {
            if drinks.isEmpty {
                Text("No favorite drinks available.")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                 DrinkCardView(drink: drinks[currentIndex])
                     .id(currentIndex) // Force view update when index changes.
                     .offset(x: offset.width, y: 0)
                     .gesture(
                         DragGesture()
                             .onChanged { gesture in
                                 offset = gesture.translation
                             }
                             .onEnded { _ in
                                 withAnimation {
                                     if offset.width > 50 { // swipe right
                                         if currentIndex < drinks.count - 1 {
                                             currentIndex += 1
                                         } else { // if at the last index, loop back
                                             currentIndex = 0
                                         }
                                     } else if offset.width < -50 { // swipe left
                                         if currentIndex > 0 {
                                             currentIndex -= 1
                                         }
                                     }
                                     offset = .zero
                                 }
                             }
                     )
             }
        }
    }
}

#Preview {
    FavDrinkCardView()
        .padding()
}
