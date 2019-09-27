import Foundation

// Расширение чтобы чекать валидность логина

extension String {
    
    enum ValidityType {
        case login
    }
    
    enum Regex: String {
        case login = "[a-zA-Z0-9-\\_]{4,14}"
    }
    
    func isValid(_ validType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .login:
            regex = Regex.login.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
