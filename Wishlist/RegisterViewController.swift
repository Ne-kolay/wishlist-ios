import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - UI Elements
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var emailTextField: UITextField!
    var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        view.backgroundColor = .white
        
        // Настройка текстовых полей
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
        // Настройка кнопки регистрации
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        // Установка авто-расставления для элементов
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            registerButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Register Button Action
    @objc func registerTapped() {
        // Получаем данные из текстовых полей
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let email = emailTextField.text else {
            print("Заполните все поля!")
            return
        }
        
        // Отправляем запрос на сервер для регистрации
        registerUser(username: username, password: password, email: email)
    }
    
    // MARK: - Register User
    func registerUser(username: String, password: String, email: String) {
        guard let url = URL(string: "http://192.168.3.26:8080/users/register") else {
            print("Неверный URL")
            return
        }
        
        // Параметры для запроса
        let parameters = [
            "username": username,
            "password": password,
            "email": email
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Преобразуем параметры в JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Ошибка при сериализации JSON: \(error)")
            return
        }
        
        // Выполнение запроса
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка при запросе: \(error)")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Ответ от сервера: \(responseString)")
                }
            }
        }
        
        task.resume()
    }
}
