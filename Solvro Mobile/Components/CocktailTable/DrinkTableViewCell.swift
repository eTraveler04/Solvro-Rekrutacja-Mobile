//
//  DrinkTableViewCell.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 11/03/2025.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    // Utworzenie pionowego stack view (VStack)
    let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical         // ustawienie osi pionowej
        stackView.alignment = .center      // wyśrodkowanie elementów w poziomie
        stackView.spacing = 8              // odstęp między elementami
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // ImageView, który wyświetli obraz
    let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill  // skalowanie obrazu tak, aby był widoczny cały
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label z nazwą drinka
    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center       // wyśrodkowanie tekstu
        label.numberOfLines = 0             // możliwość łamania tekstu
        // Ustawienie czcionki na "Noteworthy-Bold" w rozmiarze 32
        label.font = UIFont(name: "Noteworthy-Bold", size: 24)
        return label
    }()
    
    // Dodajemy przycisk symbolizujący ulubiony drink
    let favoriteButton: UIButton = {
        let button = UIButton()
        // Ustawiamy początkowy obraz przycisku jako nieulubiony ("star")
        let image = UIImage(systemName: "star")
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow  // ustawienie koloru ikony, można dostosować wg potrzeb
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Przechowywanie aktualnie wyświetlanego drinka
    private var currentDrink: Drink?
    
    // Closure, która zostanie wywołana, gdy użytkownik kliknie przycisk favorite
    var favoriteButtonAction: (() -> Void)?
    
    // Przechowywanie zadania pobierania obrazu
    var imageDownloadTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // Konfiguracja widoków komórki
    private func setupViews() {
        contentView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(drinkImageView)
        verticalStack.addArrangedSubview(drinkNameLabel)
        
        // Ustawiamy constraints dla verticalStack, aby zajmował część przestrzeni komórki
        // Modyfikujemy trailing constraint, aby zostawić miejsce na favoriteButton
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        // Ustalenie rozmiaru obrazu – tutaj ustawiamy wysokość, którą możesz zmienić wedle potrzeb
        NSLayoutConstraint.activate([
            drinkImageView.heightAnchor.constraint(equalToConstant: 150),
            drinkImageView.widthAnchor.constraint(equalTo: verticalStack.widthAnchor)
        ])
        
        // Dodajemy favoriteButton do contentView
        contentView.addSubview(favoriteButton)
        
        // Center the button vertically with the drinkImageView
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: drinkImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: drinkImageView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)

        ])
        
        // Ustawiamy target dla przycisku
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    // Metoda przy kliknięciu przycisku
     @objc private func favoriteButtonTapped() {
         guard let drink = currentDrink else { return }
         
         // Jeśli drink jest już ulubiony, usuwamy go, w przeciwnym przypadku dodajemy
         if FavoritesManager.shared.isFavorite(drink: drink) {
             FavoritesManager.shared.removeFavorite(drink: drink)
         } else {
             FavoritesManager.shared.addFavorite(drink: drink)
         }
         
         // Aktualizujemy ikonę przycisku na podstawie nowego stanu
         updateFavoriteButton(isFavorite: FavoritesManager.shared.isFavorite(drink: drink))
     }
    
    // Metoda aktualizująca ikonę przycisku w zależności od statusu ulubionego drinka
    func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Anulujemy poprzednie zadanie pobierania obrazu, jeśli jeszcze trwa
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        
        drinkImageView.image = nil
        drinkNameLabel.text = nil
        // Zerujemy closure (aby nie utrzymywać starych referencji)
        favoriteButtonAction = nil
    }
}

extension DrinkTableViewCell {
    // Nowa metoda do konfiguracji komórki na podstawie modelu Drink
    func configure(with drink: Drink) {
        currentDrink = drink // dodaj to przypisanie
        drinkNameLabel.text = drink.name
        drinkImageView.image = nil
        let drinkId = drink.id
        let isFavorite = FavoritesManager.shared.favoriteDrinks.contains { $0.id == drinkId }
        updateFavoriteButton(isFavorite: isFavorite)
        
        if let url = URL(string: drink.imageUrl) {
            imageDownloadTask?.cancel()
            imageDownloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      error == nil,
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.drinkImageView.image = image
                }
            }
            imageDownloadTask?.resume()
        }
    }

}
