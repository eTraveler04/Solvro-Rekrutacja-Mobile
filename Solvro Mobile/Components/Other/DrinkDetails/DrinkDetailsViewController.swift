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
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // New label for displaying ingredients.
    let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(drink: Drink) {
        self.drink = drink
        super.init(nibName: nil, bundle: nil)
        // Change the modal presentation style to fully transparent
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's background color to clear
        view.backgroundColor = .clear
        
        // Setup the background image to fill the entire view.
        if let bgImage = UIImage(named: "CardBackground") {
            let bgImageView = UIImageView()
            bgImageView.image = bgImage
            bgImageView.contentMode = .scaleAspectFill
            bgImageView.clipsToBounds = true
            bgImageView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(bgImageView, at: 0) // Place behind other subviews
            
            NSLayoutConstraint.activate([
                bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
                bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        setupViews()
        configureViews()
        fetchAndDisplayIngredients()
        
        // Replace the default Done button with a custom transparent one
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .clear
        doneButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        doneButton.titleLabel?.font = UIFont(name: "Noteworthy-Bold", size: 20)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    func setupViews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(ingredientsLabel)
        
        imageView.backgroundColor = .clear
        nameLabel.backgroundColor = .clear
        instructionsLabel.backgroundColor = .clear
        ingredientsLabel.backgroundColor = .clear
        
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
        APIManager.shared.fetchIngredients(for: drink) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ingredients):
                    
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
