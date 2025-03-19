import SwiftUI

enum SwipeDirection {
    case left, right
}

struct DrinkCardView: View {
    let drink: Drink
    var onSwipe: ((SwipeDirection) -> Void)? // Callback informujący rodzica o kierunku swipe

    @State private var offset = CGSize.zero
    @State private var color: Color = .white

    var body: some View {
        // Define a common drag gesture closure to reuse in both cases.
        let dragGesture = DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
                withAnimation {
                    color = offset.width > 0 ? Color.green.opacity(0.1) : Color.red.opacity(0.1)
                }
            }
            .onEnded { _ in
                let threshold: CGFloat = 50
                // Sprawdzamy, czy przesunięcie przekroczyło próg
                if abs(offset.width) > threshold {
                    let direction: SwipeDirection = offset.width > 0 ? .right : .left
                    // Animacja przesunięcia karty poza ekran
                    withAnimation(.easeOut(duration: 0.3)) {
                        offset.width = direction == .right ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width
                    }
                    // Po zakończeniu animacji wywołaj callback i zresetuj stan
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onSwipe?(direction)
                        withAnimation {
                            offset = .zero
                            color = .white
                        }
                    }
                } else {
                    // Jeśli przesunięcie nie przekroczyło progu, powrót do stanu początkowego
                    withAnimation {
                        offset = .zero
                        color = .white
                    }
                }
            }

        // Check if drink.id == -1, display only the image.
        if drink.id == -1 {
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(color)
                        .shadow(radius: 10)
                    Image("DefaultCard")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 340, maxHeight: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .frame(height: 500)                  // Ustala wysokość karty
                .frame(maxWidth: .infinity)          // Zapewnia, że karta zajmuje całą szerokość kontenera
                .padding(.horizontal, 20)            // Dodaje marginesy z lewej i prawej
                .offset(x: offset.width, y: offset.height * 0.4)
                .rotationEffect(.degrees(Double(offset.width / 40)))
                .gesture(dragGesture)
            )
        } else {
            // Full card view with all details.
            return AnyView(
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
                .gesture(dragGesture)
            )
        }
    }
}

#Preview {
    DrinkCardView(
        drink: Drink(
            id: -1,
            name: "Cosmopolitan",
            category: "Cocktail",
            glass: "Cocktail glass",
            instructions: "Add cranberry juice, triple sec, vodka, and a squeeze of lime juice to a shaker with ice. Shake well and strain into a chilled cocktail glass.",
            imageUrl: "https://example.com/cosmopolitan.jpg",
            alcoholic: true,
            ingredients: nil,
            createdAt: nil,
            updatedAt: nil
        )
    ) {
        direction in
        // Obsługa callbacku w podglądzie (Preview)
        print("Swiped \(direction)")
    }
    .padding()
}
