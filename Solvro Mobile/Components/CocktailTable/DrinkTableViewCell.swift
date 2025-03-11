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
        
        // Ustawiamy constraints dla verticalStack, aby zajmował większość przestrzeni komórki
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Ustalenie rozmiaru obrazu – tutaj ustawiamy wysokość, którą możesz zmienić wedle potrzeb
            drinkImageView.heightAnchor.constraint(equalToConstant: 150),
            drinkImageView.widthAnchor.constraint(equalTo: verticalStack.widthAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        drinkImageView.image = nil
        drinkNameLabel.text = nil
    }
}
