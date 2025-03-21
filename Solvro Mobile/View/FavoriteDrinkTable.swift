import Foundation
import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var favoritesManager = FavoritesManager.shared

    @State private var displayDrinks: [Drink] = []
    @State private var selectedDrink: Drink? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(displayDrinks) { drink in
                    HStack(spacing: 16) {
                        if let url = URL(string: drink.imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(drink.name)
                                .font(.headline)
                            Text(drink.category)
                                .font(.subheadline)
                            Text(drink.glass)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Button(action: {
                            if favoritesManager.isFavorite(drink: drink) {
                                favoritesManager.removeFavorite(drink: drink)
                            } else {
                                favoritesManager.addFavorite(drink: drink)
                            }
                        }) {
                            Image(systemName: favoritesManager.isFavorite(drink: drink) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedDrink = drink
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteDrink)
            }
            .listRowSpacing(8)
            .navigationTitle("Ulubione Drinki")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                displayDrinks = favoritesManager.favoriteDrinks
            }
            .sheet(item: $selectedDrink) { drink in
                DrinkDetailsViewControllerRepresentable(drink: drink)
            }
        }
    }

    private func deleteDrink(at offsets: IndexSet) {
        offsets.forEach { index in
            let drink = displayDrinks[index]
            favoritesManager.removeFavorite(drink: drink)
        }
    }
}

