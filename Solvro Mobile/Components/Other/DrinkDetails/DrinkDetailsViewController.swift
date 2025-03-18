//
//  DrinkDetailsViewController.swift
//  Solvro Mobile
//
//  Created by Szymon Protynski on 18/03/2025.
//

import UIKit

class DrinkDetailsViewController: UIViewController {
 let drink: Drink

 // MARK: - UI Components
 let imageView: UIImageView = {
     let iv = UIImageView()
     iv.contentMode = .scaleAspectFill
     iv.clipsToBounds = true
     iv.translatesAutoresizingMaskIntoConstraints = false
     return iv
 }()

 let nameLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.boldSystemFont(ofSize: 24)
     label.textAlignment = .center
     label.translatesAutoresizingMaskIntoConstraints = false
     return label
 }()

 let instructionsLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.systemFont(ofSize: 16)
     label.numberOfLines = 0
     label.translatesAutoresizingMaskIntoConstraints = false
     return label
 }()

 init(drink: Drink) {
     self.drink = drink
     super.init(nibName: nil, bundle: nil)
     modalPresentationStyle = .formSheet
 }

 required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
 }

 override func viewDidLoad() {
     super.viewDidLoad()
     view.backgroundColor = .systemBackground
     setupViews()
     configureViews()
 }

 func setupViews() {
     view.addSubview(imageView)
     view.addSubview(nameLabel)
     view.addSubview(instructionsLabel)
     
     // Add a Done button to dismiss
     navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                         target: self,
                                                         action: #selector(closeTapped))
     
     NSLayoutConstraint.activate([
         imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         imageView.widthAnchor.constraint(equalToConstant: 200),
         imageView.heightAnchor.constraint(equalToConstant: 200),
         
         nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
         nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         
         instructionsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
         instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
     ])
 }

 func configureViews() {
     nameLabel.text = drink.name
     instructionsLabel.text = drink.instructions

     if let url = URL(string: drink.imageUrl) {
         URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
             guard let self = self,
                   let data = data,
                   error == nil,
                   let image = UIImage(data: data)
             else { return }
             DispatchQueue.main.async {
                 self.imageView.image = image
             }
         }.resume()
     }
 }
 
 @objc func closeTapped() {
     dismiss(animated: true, completion: nil)
 }
}
