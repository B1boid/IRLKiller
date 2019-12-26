import UIKit

class TabBarViewController: UITabBarController {
    
    private var loadingViewController: LoadingAnimationViewController!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (loadingViewController == nil) {
            print("WHYYYY")
            loadingViewController = LoadingAnimationViewController()
            loadingViewController.modalPresentationStyle = .fullScreen
//            showLoadingViewController(animated: true)
        }
    }
    
    func showLoadingViewController(animated: Bool) {
        print("HEY THERE")
//        self.present(loadingViewController, animated: animated, completion: nil)
    }
    
    func hideLoadingViewController(animated: Bool) {
        loadingViewController.dismiss(animated: animated, completion: nil)
    }
}
