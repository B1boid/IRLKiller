import UIKit
import Firebase

class RootViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login")
            self.present(login, animated: true, completion: nil)
        }
    }
}
