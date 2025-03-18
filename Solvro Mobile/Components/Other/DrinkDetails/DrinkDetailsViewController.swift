import UIKit

class DrinkDetailsViewController: UIViewController {
    let drink: Drink
    // Existing UI components (e.g., imageView, nameLabel, instructionsLabel) are presumed.
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
    
    // New label for displaying ingredients.
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
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
        fetchAndDisplayIngredients()
    }
    
    func setupViews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(ingredientsLabel)
        
        // For simplicity, using basic constraints. Adapt as needed.
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
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            ingredientsLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 20),
            ingredientsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Set up the navigation bar Done button if needed.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(closeTapped))
    }
    
    func configureViews() {
        nameLabel.text = drink.name
        instructionsLabel.text = drink.instructions
        
        if let url = URL(string: drink.imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil,
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }.resume()
        }
    }
    
    func fetchAndDisplayIngredients() {
        // Use the convenience method that accepts a Drink.
        APIManager.shared.fetchIngredients(for: drink) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ingredients):
                    
                    // Map each Ingredient to its name property and join them.
                    let ingredientNames = ingredients.map { $0.name }
                    self?.ingredientsLabel.text = "Ingredients: " + ingredientNames.joined(separator: ", ")
                case .failure(let error):
                    
                    self?.ingredientsLabel.text = "Failed to load ingredients: \(error.localizedDescription)"
                }
            }
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
