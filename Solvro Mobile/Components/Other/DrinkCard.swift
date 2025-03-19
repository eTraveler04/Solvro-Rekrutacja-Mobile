//
//  DrinkCard.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 19/03/2025.
//

import SwiftUI

struct DrinkCardView: View {
    let drink: Drink

    @ObservedObject var favoritesManager = FavoritesManager.shared

    @State private var offset = CGSize.zero
    @State private var color: Color = .white
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(drink.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            if let url = URL(string: drink.imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                        .frame(width: 130, height: 130)
                        .frame(maxWidth: .infinity)
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .frame(maxWidth: .infinity)
            }
            
            Text(drink.category)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            
            Text(drink.glass)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            

            Spacer()
        }
        .frame(height: 450)
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(color)
                .shadow(radius: 10)
        )
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        color = offset.width > 0 ? .green.opacity(0.1) : .red.opacity(0.1)
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        offset = .zero
                        color = .white
                    }
                }
        )
    }
}

#Preview {
    DrinkCardView(
        drink: Drink(
            id: 11,
            name: "Cosmopolitan",
            category: "Cocktail",
            glass: "Cocktail glass",
            instructions: "Add cranberry juice, triple sec, vodka, and a squeeze of lime juice to a shaker with ice. Shake well and strain into a chilled cocktail glass.",
            imageUrl: "https://example.com/cosmopolitan.jpg",
            alcoholic: true,
            ingredients: nil, // brak składników, bo to pole jest opcjonalne
            createdAt: nil,
            updatedAt: nil
        )
    )
    .padding()
}
