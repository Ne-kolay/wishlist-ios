import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        // Проверяем, залогинен ли пользователь
        if let userEmail = AuthManager.shared.getUserEmail(), !userEmail.isEmpty {
            // Если пользователь залогинен, открываем Dashboard
            let dashboardVC = DashboardViewController()  // или ваш главный экран
            window.rootViewController = UINavigationController(rootViewController: dashboardVC)
        } else {
            // Если не залогинен, открываем LoginViewController
            let loginVC = LoginViewController()
            window.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
