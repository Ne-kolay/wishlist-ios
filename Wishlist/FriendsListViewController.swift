import UIKit

class FriendsListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои друзья"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let friendsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI
        view.backgroundColor = .white
        setupUI()
        
        // Set up the table view
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(friendsTableView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Table view
            friendsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            friendsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendsListViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Пока что отображаем 10 заглушек
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        cell.textLabel?.text = "Друг \(indexPath.row + 1)"
        return cell
    }
    
    // UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Здесь можно добавить логику для перехода к деталям друга
        print("Выбран друг \(indexPath.row + 1)")
    }
}
