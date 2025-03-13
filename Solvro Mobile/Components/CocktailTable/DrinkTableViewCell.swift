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
        imageView.contentMode = .scaleAspectFit   // skalowanie obrazu tak, aby był widoczny cały
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Label z nazwą drinka
    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center       // wyśrodkowanie tekstu
        label.numberOfLines = 0             // możliwość łamania tekstu
        label.font = UIFont.systemFont(ofSize: 18) // powiększony rozmiar czcionki
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
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60)
        ])
        
        // Ustalenie rozmiaru obrazu – tutaj ustawiamy wysokość, którą możesz zmienić wedle potrzeb
        NSLayoutConstraint.activate([
            drinkImageView.heightAnchor.constraint(equalToConstant: 150),
            drinkImageView.widthAnchor.constraint(equalTo: verticalStack.widthAnchor)
        ])
        
        // Dodajemy favoriteButton do contentView
        contentView.addSubview(favoriteButton)
        // Ustawiamy constraints przycisku (umieszczamy go w prawym górnym rogu)
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Ustawiamy target dla przycisku
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    // Metoda wywoływana, gdy przycisk zostanie naciśnięty
    @objc private func favoriteButtonTapped() {
        favoriteButtonAction?()
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
        // Ustawiamy nazwę drinka
        drinkNameLabel.text = drink.name
        
        // Resetujemy obraz – przygotowujemy placeholder (tutaj nil, ale możesz ustawić obraz zastępczy)
        drinkImageView.image = nil
        
        // Jeśli mamy URL obrazu, pobieramy go asynchronicznie
        if let url = URL(string: drink.imageUrl) {
            // Anulujemy poprzednie zadanie, jeśli istnieje
            imageDownloadTask?.cancel()
            imageDownloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      error == nil,
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    // Upewniamy się, że komórka nadal reprezentuje ten sam drink
                    self.drinkImageView.image = image
                }
            }
            imageDownloadTask?.resume()
        }
    }
}
