import Foundation
class AuthManager {
    
    static let shared = AuthManager()
    
    private let userDefaults = UserDefaults.standard
    private let userEmailKey = "user_email"
    
    private init() {}
    
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
    
    // Запрос на сервер для получения userId по email
    func getUserIdFromServer(completion: @escaping (Int?) -> Void) {
        guard let email = getUserEmail() else {
            completion(nil)
            return
        }
        
        // Создание URL запроса
        let url = URL(string: "http://192.168.3.26:8080/users/id/\(email)")! // Замени на свой URL
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            // Парсим ответ, предполагая, что в ответе будет userId
            if let userId = try? JSONDecoder().decode(Int.self, from: data) {
                completion(userId)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
