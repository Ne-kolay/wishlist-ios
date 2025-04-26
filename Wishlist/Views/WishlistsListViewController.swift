import UIKit

class WishlistListsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои вишлисты"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let wishlistTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - Properties
    private var wishlists: [WishlistDTO] = []
    var userId: Int?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        wishlistTableView.dataSource = self
        wishlistTableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addWishlistTapped)
        )
        
        if let userId = userId {
            fetchWishlists(for: userId)
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(wishlistTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            wishlistTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            wishlistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wishlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Networking
    private func fetchWishlists(for userId: Int) {
        guard let url = URL(string: "http://192.168.3.26:8080/wishlists/user/\(userId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при запросе: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(message: "Ошибка при загрузке вишлистов: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Не удалось получить данные.")
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Полученный JSON:\n\(jsonString)")
            }

            do {
                let wishlists = try JSONDecoder().decode([WishlistDTO].self, from: data)
                DispatchQueue.main.async {
                    self.wishlists = wishlists
                    self.wishlistTableView.reloadData()
                }
            } catch {
                print("Ошибка при декодировании данных: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(message: "Ошибка при обработке данных.")
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func addWishlistTapped() {
        let createVC = CreateWishlistViewController()
        createVC.userId = self.userId
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - Delete Wishlist
    private func deleteWishlist(_ wishlist: WishlistDTO) {
        guard let url = URL(string: "http://192.168.3.26:8080/wishlists/\(wishlist.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при удалении: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(message: "Ошибка при удалении вишлиста: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.fetchWishlists(for: self.userId ?? 0) // Обновляем список после удаления
            }
        }
        
        task.resume()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension WishlistListsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wishlist = wishlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = wishlist.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedWishlist = wishlists[indexPath.row]
        let detailsVC = WishlistDetailsViewController()
        detailsVC.wishlist = selectedWishlist
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: - Swipe to delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") { (action, indexPath) in
            let wishlistToDelete = self.wishlists[indexPath.row]
            
            let alert = UIAlertController(title: "Подтвердите удаление", message: "Вы уверены, что хотите удалить этот вишлист?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.deleteWishlist(wishlistToDelete)
            }))
            
            self.present(alert, animated: true)
        }
        
        return [deleteAction]
    }
}
