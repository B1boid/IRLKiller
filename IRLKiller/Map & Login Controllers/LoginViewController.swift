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
    static let askEnterLoginMsg = "Enter your login:"
    
    var w: CGFloat!
    var h: CGFloat!
    let TC = TimeConverter()
    
    // Окно для ввода логина
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.text = askEnterLoginMsg
        textField.textColor = .white
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor  = .clear
        textField.autocorrectionType = .no
        textField.adjustsFontSizeToFitWidth = true
        textField.maxLength = 14
        return textField
    }()
    
    // Название игры
    let gameNameLabel: UILabel = {
        let label = UILabel()
        label.text = "IRLKiller"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // Кпонка для регистрации
    let entryButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Entry", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
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
        label.alpha = 0.5
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
        bgImageView.frame = self.view.frame
        bgImageView.layer.zPosition = -1
        
        // Меняем размеры которые зависят от размера view
        entryButton.titleLabel?.font =  UIFont(name: "Marker Felt", size: 30)
        gameNameLabel.font = UIFont(name: "Rockwell", size: 120)
        loginTextField.font = UIFont(name: "Rockwell", size: 20)
        
        gameNameLabel.baselineAdjustment           = .alignCenters
        entryButton.titleLabel?.baselineAdjustment = .alignCenters
    }
    
    private func checkLoginValidity(login: String) -> Bool {
        
        guard login != "Enter your login:" else {
            showThenHideErrorMsg(duration: 5.0, error: "Please enter login")
            return false;
        }
        
        guard login.count > 3 else {
            showThenHideErrorMsg(duration: 5.0, error: "Login must have at least 4 symbols")
            return false;
        }
        
        guard login.isValid(.login) else {
            showThenHideErrorMsg(duration: 6.0, error: "Login must have only letters, digits or special symbols(\"-\",\"_\")")
            return false;
        }
        
        return true;
    }
    
    private func doLogin() {
        
        // Проверяем валидность логина и выводим сообщение об этом
        let login = loginTextField.text!.trimmingCharacters(in: .whitespaces)
        
        guard checkLoginValidity(login: login) else { return }
        
        //Подключаемся к БД и ищем занят ли логин
        
        let refToUser = DataBaseManager.Refs.databaseUserNames.child("/\(login.lowercased())")
        
        refToUser.observeSingleEvent(of: .value, with: { snapshot in
            guard !snapshot.exists() else {
                self.showThenHideErrorMsg(duration: 5.0, error: "Login is used")
                return
            }
            
            self.loadingImageView.frame = self.view.frame
            self.view.addSubview(self.loadingImageView)
            
            let values: [DatabaseKeys: Any] = [ .login       : login,
                                                .time_online : TimeConverter.convertToUTC(in: .minute),
                                                .time_death  : TimeConverter.convertToUTC(in: .minute),
                                                .latitude    : 40.74699,
                                                .longitude   : -73.98742,
                                                .health      : 100,
                                                .rating      : 1200 ]
            
            DataBaseManager.shared.createUser(login: login, values: values) {
                self.loadingImageView.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func editGreetMsg(writeGreetIfEmpty: Bool) {
        if loginTextField.text == LoginViewController.askEnterLoginMsg {
            loginTextField.text = ""
        }
        // Если нажимаем вне клавиатуры и строка пуста то мы пишем сообщение о вводе пароля
        if writeGreetIfEmpty && loginTextField.text!.isEmpty {
            loginTextField.text = LoginViewController.askEnterLoginMsg
        }
    }
    
    private func showThenHideErrorMsg(duration: TimeInterval, error: String) {
        errorMsgLabel.text = error
        self.errorMsgLabel.alpha = 1
        UIView.animate(withDuration: duration) {
            self.errorMsgLabel.alpha = 0
        }
    }
    
    @objc private func clearErrorMsg() {
        errorMsgLabel.text = ""
    }
    
    //По нажатию return на клавиатуре
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder() //Закрывает клавиатуру
        doLogin()
        return true
    }
    
    /* Когда начинаем печатать пропадает надпись что логин неправильный
     в случае неправильно введеного логина в первый раз */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editGreetMsg(writeGreetIfEmpty: false)
    }
    
    //Закрывание клавиатуры по нажатию на другую область экрана
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editGreetMsg(writeGreetIfEmpty: true)
        clearErrorMsg()
        self.view.endEditing(true)
    }
}
