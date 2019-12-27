import Foundation
import Firebase
import FirebaseDatabase
import FirebaseUI

enum DatabaseKeys: String {
    case health
    case latitude
    case longitude
    case rating
    case login
    case time_death
    case time_online
}

class DataBaseManager {
    
    static let shared: DataBaseManager = DataBaseManager()
    
    private init() {}
    
    enum Refs {
        static let databaseRoot: DatabaseReference      = Database.database().reference()
        static let databaseUsers: DatabaseReference     = databaseRoot.child("users")
        static let databaseUserNames: DatabaseReference = databaseRoot.child("usernames")
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var refToUser: DatabaseReference? {
        get { guard let user = currentUser else { return nil }
            return Refs.databaseUsers.child("/\(user.uid)")
        }
    }
    
    static var myLogin: String?
    static var myRating: Int?
    static var players = [String : Player]()
    
    
    // MARK:- Create users function
    func createUser(login: String, values: [DatabaseKeys: Any], completion: @escaping () -> Void) {
        
        // Создаем связку почты и пароля для входа,она нужна только чтобы использовать возможность авторизации FirebaseAuth ,от пользователя понадобится только логин
        
        let fakeEmail = login + "mail@mail.com"
        let fakePassword = login + "pass"
        
        Auth.auth().createUser(withEmail: fakeEmail, password: fakePassword) { (result, error) in
            
            guard error == nil                else { print(error!.localizedDescription); return }
            guard let result = result         else { print("No result"); return }
            
            // Создаем две ветки в БД
            // users в ней будут все данные пользователя и привязаны они к uid
            // usernames нужна для проверки уникальности логина, в ней связка логин : uid
            let uid = result.user.uid
            
            DataBaseManager.shared.updateUserValues(for: uid, with: values)
            
            Refs.databaseUserNames.updateChildValues([ login.lowercased() : uid ])
            
            completion()
        }
    }
    
    // MARK:- Update value (attributes for users)
    func updateUserValues(for uid: String?, with values: [DatabaseKeys: Any]) {
        guard let UID = uid  else { return }
        let reference = Refs.databaseUsers.child("/\(UID)")
        let stringKeys = values.map( { (key, _) in key.rawValue } )
        let keyStringValues = Dictionary(uniqueKeysWithValues: zip(stringKeys, values.map({ $0.value })))
        reference.updateChildValues(keyStringValues)
    }
}
