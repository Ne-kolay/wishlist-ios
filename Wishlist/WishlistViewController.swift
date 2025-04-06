import UIKit

class WishlistListViewController: UIViewController {
    
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI
        view.backgroundColor = .white
        setupUI()
        
        // Set up the table view
        wishlistTableView.dataSource = self
        wishlistTableView.delegate = self
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(wishlistTableView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Table view
            wishlistTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            wishlistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wishlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension WishlistListViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Пока что отображаем 10 заглушек
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Вишлист \(indexPath.row + 1)"
        return cell
    }
    
    // UITableViewDelegate methods (если нужно добавить действия при выборе элемента)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Здесь можно добавить логику для перехода к деталям вишлиста
        print("Выбран вишлист \(indexPath.row + 1)")
    }
}
