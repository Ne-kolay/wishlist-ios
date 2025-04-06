import UIKit

class DashboardViewController: UIViewController {

    // MARK: - UI Elements
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let wishlistButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Мои вишлисты", for: .normal)
        button.addTarget(self, action: #selector(navigateToWishlistList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let friendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Мои друзья", for: .normal)
        button.addTarget(self, action: #selector(navigateToFriendsList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Настройки", for: .normal)
        button.addTarget(self, action: #selector(navigateToSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Кнопка выхода
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UI
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(wishlistButton)
        view.addSubview(friendsButton)
        view.addSubview(settingsButton)
        view.addSubview(logoutButton) // Добавляем кнопку выхода

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Wishlist button
            wishlistButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            wishlistButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Friends button
            friendsButton.topAnchor.constraint(equalTo: wishlistButton.bottomAnchor, constant: 20),
            friendsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Settings button
            settingsButton.topAnchor.constraint(equalTo: friendsButton.bottomAnchor, constant: 20),
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Logout button
            logoutButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 30),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Navigation Actions
    @objc private func navigateToWishlistList() {
        let wishlistListVC = WishlistListViewController() // Экран списка вишлистов
        navigationController?.pushViewController(wishlistListVC, animated: true)
    }
    
    @objc private func navigateToFriendsList() {
        let friendsListVC = FriendsListViewController() // Экран списка друзей
        navigationController?.pushViewController(friendsListVC, animated: true)
    }
    
    @objc private func navigateToSettings() {
        let settingsVC = SettingsViewController() // Экран настроек
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    // MARK: - Logout Action
    @objc private func logoutTapped() {
        // Очистить информацию о пользователе
        let authManager = AuthManager()
        authManager.logout()
        
        // Вернуться на экран логина
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
    }
}
