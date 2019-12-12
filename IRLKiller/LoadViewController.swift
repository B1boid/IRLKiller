import UIKit
import Firebase


class LoadViewController: UIViewController {
    var hasConnection = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasConnection = true
        checkInternetConnection()
        NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(statusManager),
                                       name: .none,
                                       object: nil)
        
        showInternetAlert()
        
    }
    
    func showInternetAlert(){
        hasConnection = false
        let alert = UIAlertController(title: "No internet connection",message: "Please connect your device to the internet.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.hasConnection = true
            self.checkInternetConnection()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkInternetConnection(){
        if !Reachability.isConnectedToNetwork(){
            if hasConnection{
                showInternetAlert()
            }
            //print("Internet Connection not Available!")
        }else{
            // не робит
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func statusManager(_ notification: Notification) {
        checkInternetConnection()
    }
    
    
}
