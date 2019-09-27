import UIKit
import FirebaseUI
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginCheckValidityText: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBAction func buttonLoginTouched(_ sender: Any) {
        doLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Будет тру начиная со второго запуска приложения и будет авто переход в меню
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "showMenu", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
    }
    
    func doLogin(){
        // Проверяем валидность логина и выводим сообщение об этом
        let conditionForLoginValidity = loginTextField.text?.isValid(.login) ?? false
        guard conditionForLoginValidity else {
            loginCheckValidityText.textColor = UIColor.red
            loginCheckValidityText.text = " Incorrect login "
            return
        }
        
        let login = loginTextField.text!
        
        //Подключаемся к БД и ищем занят ли логин
        let ref = Database.database().reference()
        ref.child("usernames/\(login.lowercased())").observeSingleEvent(of: .value, with: { snapshot in
            guard !snapshot.exists() else {
                print( "Login has already taken" )
                return
            }
            
            // Создаем связку почты и пароля для входа,она нужна только чтобы использовать возможность авторизации FirebaseAuth ,от пользователя понадобится только логин
            let email = self.loginTextField.text! + "mail@mail.com"
            let password = self.loginTextField.text! + "pass"
            
            Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
                if error == nil && result != nil {
                    print(result!.user.uid)
                    
                    //Создаем две ветки в БД
                    // users в ней будут все данные пользователя и привязаны они к uid
                    // usernames нужна для проверки уникальности логина, в ней связка логин:uid
                    ref.child("users").updateChildValues([result!.user.uid:["login":login, "score":0]])
                    ref.child("usernames").updateChildValues([login.lowercased():result!.user.uid])
                    self.performSegue(withIdentifier: "showMenu", sender: self)
                } else {
                    print(error!.localizedDescription)
                }
            }
        })
    }
    
    func clearCheckMessage() {
        loginCheckValidityText.text = ""
    }
    
    /* Когда начинаем печатать пропадает надпись что логин неправильный
     в случае неправильно введеного логина в первый раз */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearCheckMessage()
    }
    
    //По нажатию return на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder() //Закрывает клавиатуру
        doLogin()
        return true
    }
    
    //Закрывание клавиатуры по нажатию на другую область экрана
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearCheckMessage()
        self.view.endEditing(true)
    }
}

