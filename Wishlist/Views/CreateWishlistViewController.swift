import UIKit


class CreateWishlistViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создать вишлист"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название вишлиста"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Описание"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let privacySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Публичный", "Только друзья", "Приватный"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    var userId: Int! // передаётся с предыдущего экрана
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        createButton.addTarget(self, action: #selector(createWishlistTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(privacySegmentedControl)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            privacySegmentedControl.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            privacySegmentedControl.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            privacySegmentedControl.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            createButton.topAnchor.constraint(equalTo: privacySegmentedControl.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 150),
            createButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func createWishlistTapped() {
        guard let title = nameTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля.")
            return
        }

        let privacyOptions = ["PUBLIC", "FRIENDS", "PRIVATE"]
        let selectedPrivacy = privacyOptions[privacySegmentedControl.selectedSegmentIndex]

        let wishlistData: [String: Any] = [
            "name": title,
            "description": description,
            "privacyLevel": selectedPrivacy,
            "userId": userId!
        ]

        guard let url = URL(string: "http://192.168.3.26:8080/wishlists/create") else {
            print("❌ Неверный URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: wishlistData, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            print("❌ Ошибка сериализации JSON: \(error)")
            showAlert(message: "Ошибка при подготовке запроса")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Ошибка при выполнении запроса: \(error)")
                    self.showAlert(message: "Ошибка: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    self.showAlert(message: "Ошибка при создании вишлиста")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let wishlistDTO = try decoder.decode(WishlistDTO.self, from: data)
                    self.navigateToWishlistDetails(wishlistDTO)
                } catch {
                    print("❌ Ошибка при декодировании ответа: \(error)")
                    self.showAlert(message: "Ошибка при разборе ответа сервера")
                }
            }
        }.resume()
    }

    private func navigateToWishlistDetails(_ wishlist: WishlistDTO) {
        if let navController = self.navigationController,
           let wishlistListVC = navController.viewControllers.first(where: { $0 is WishlistListsViewController }) {

            let detailsVC = WishlistDetailsViewController()
            detailsVC.wishlist = wishlist

            navController.popToViewController(wishlistListVC, animated: false)
            navController.pushViewController(detailsVC, animated: true)
        } else {
            let detailsVC = WishlistDetailsViewController()
            detailsVC.wishlist = wishlist
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
