import UIKit
import FirebaseUI
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // 1param - параметр смещение относительно начала координат по x
    // 2param - относительно предыдущего view
    // 3param - высота текущего view
    // 4param - текущее view
    typealias OffsetForView = (xOffset: CGFloat, yOffset: CGFloat, height: CGFloat, view: UIView)
    
    static let loadingImageName = "bg"
    static let bgImageName = "bg"
    static let greetingMsg = "Enter your login:"
    var w: CGFloat!
    var h: CGFloat!
    
    // Окно для ввода логина
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.text = greetingMsg
        textField.textColor = .white
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor  = .clear
        textField.maxLength = 18
        return textField
    }()
    
    // Название игры
    let gameNameLabel: UILabel = {
        let label = UILabel()
        label.text = "IRLKiller"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // Кпонка для регистрации
    let entryButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Entry", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 5
        button.tintColor = .white
        button.addTarget(self, action: #selector(logginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Показывается если логин занят или введен некоректный логин
    let errorMsgLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    
    // Задний фон нашего приложения
    let bgImageView: UIImageView = UIImageView(image: UIImage(named: bgImageName))
    let loadingImageView: UIImageView = UIImageView(image: UIImage(named: loadingImageName))
    
    var subviews: [UIView] = []
    
    
    // Functions for actions
    @objc func logginButtonPressed() {
        doLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Будет тру начиная со второго запуска приложения и будет авто переход в меню
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "showMenu", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self

        // Adding subviews
        subviews = [
            bgImageView, gameNameLabel, loginTextField, errorMsgLabel, entryButton
        ]
        subviews.forEach { view.addSubview($0) }
    }
    
    override func viewWillLayoutSubviews() {
        // В этот момент все фрэймы уже проставлены
        w = view.frame.width
        h = view.frame.height
        let framesOfSubviews: [OffsetForView] =
        [
                (xOffset: w / 8, yOffset: h / 10, height: h / 6, view: gameNameLabel),
                (xOffset: w / 8, yOffset: h / 5, height: h / 15, view: loginTextField),
                (xOffset: w / 8, yOffset: h / 15, height: h / 10, view: errorMsgLabel),
                (xOffset: (5 * w) / 16, yOffset: h / 10, height: h / 15, view: entryButton)
        ]
        
        // Располагаем атрибуты относительно друг друга
        let _ = framesOfSubviews.reduce((xOffset: 0, yOffset: 0, height: 0, view: UIView()))
        { (previous, current) -> OffsetForView in
            current.view.frame = CGRect(
                x: current.xOffset,
                y: previous.view.frame.maxY + current.yOffset,
                width: w - 2 * current.xOffset,
                height: current.height
            )
            return current
        }
        
        // Фон лежит ниже всех //
        bgImageView.frame = view.frame
        bgImageView.layer.zPosition = -1
        
        // Меняем размеры которые зависят от размера view
        entryButton.titleLabel?.font =  UIFont(name: "Marker Felt", size: entryButton.frame.height - 20)
        
        gameNameLabel.font = UIFont(
            name: "Rockwell",
            size: min(gameNameLabel.frame.height,
                      view.frame.width / CGFloat(gameNameLabel.text!.count))
        )
        
        loginTextField.font = UIFont(
            name: "Rockwell",
            size: min(loginTextField.frame.height, loginTextField.frame.width / CGFloat(14))
        )
    }
    
    func doLogin() {
        
        // Проверяем валидность логина и выводим сообщение об этом
        let login = loginTextField.text!.trimmingCharacters(in: .whitespaces)
        
        guard login.isValid(.login) else {
            errorMsgLabel.text = "Login must have at least 4 chars"
            let _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(clearErrorMsg), userInfo: nil, repeats: false)
            return
        }
    
        //Подключаемся к БД и ищем занят ли логин
        let ref = Database.database().reference()
        ref.child("usernames/\(login.lowercased())").observeSingleEvent(of: .value, with: { snapshot in
            guard !snapshot.exists() else {
                self.errorMsgLabel.text = "Login is used"
                return
            }
            
            self.loadingImageView.frame = self.view.frame
            self.view.addSubview(self.loadingImageView)
            
            // Создаем связку почты и пароля для входа,она нужна только чтобы использовать возможность авторизации FirebaseAuth ,от пользователя понадобится только логин
            
            let email = login + "mail@mail.com"
            let password = login + "pass"
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error == nil && result != nil {
                    print(result!.user.uid)
                    
                    //Создаем две ветки в БД
                    // users в ней будут все данные пользователя и привязаны они к uid
                    // usernames нужна для проверки уникальности логина, в ней связка логин:uid
                    ref.child("users").updateChildValues(
                        [ result!.user.uid : [ "login" : login, "score" : 0 ]]
                    )
                    ref.child("usernames").updateChildValues(
                        [ login.lowercased() : result!.user.uid ]
                    )
                    self.loadingImageView.removeFromSuperview()
                    self.performSegue(withIdentifier: "showMenu", sender: self)
                } else {
                    print(error!.localizedDescription)
                }
            }
        })
    }
    
    func editGreetMsg(writeGreetIfEmpty: Bool = false) {
        if loginTextField.text == LoginViewController.greetingMsg {
            loginTextField.text = ""
        }
        
        // Если нажимаем вне клавиатуры и строка пуста то мы пишем сообщение о вводе пароля
        if writeGreetIfEmpty && (loginTextField.text?.isEmpty)! {
            loginTextField.text = LoginViewController.greetingMsg
        }
    }
    
    @objc func clearErrorMsg() {
        errorMsgLabel.text = ""
    }
    
    //По нажатию return на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder() //Закрывает клавиатуру
        doLogin()
        return true
    }
    
    /* Когда начинаем печатать пропадает надпись что логин неправильный
     в случае неправильно введеного логина в первый раз */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editGreetMsg()
    }
    
    //Закрывание клавиатуры по нажатию на другую область экрана
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editGreetMsg(writeGreetIfEmpty: true)
        clearErrorMsg()
        self.view.endEditing(true)
    }
}
