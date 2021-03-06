import Foundation

// Расширение чтобы чекать валидность логина

extension String {
    
    enum ValidityType {
        case login
    }
    
    enum Regex: String {
        case login = "[a-zA-Z0-9-\\_]{4,18}"
    }
    
    func isValid(_ validType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .login:
            regex = Regex.login.rawValue
        }
        // SELF MATCHES говрит что мы будет сравнить по формату регулярных выражений SELF MATCHES %@ =
        // self подходит под шаблон %@ - это перменная с регулярным выражением //
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

