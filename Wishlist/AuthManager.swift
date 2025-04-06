import Foundation

class AuthManager {
    
    private let userDefaults = UserDefaults.standard
    private let userEmailKey = "user_email" // ключ для сохранения email
    
    // Проверка, залогинен ли пользователь
    var isUserLoggedIn: Bool {
        return getUserEmail() != nil
    }
    
    // Сохранение email пользователя (когда он успешно авторизуется)
    func saveUserEmail(_ email: String) {
        userDefaults.set(email, forKey: userEmailKey)
    }
    
    // Получение email пользователя
    func getUserEmail() -> String? {
        return userDefaults.string(forKey: userEmailKey)
    }
    
    // Удаление данных о пользователе (при выходе из системы)
    func logout() {
        userDefaults.removeObject(forKey: userEmailKey)
    }
}
