import UIKit

class ContainerViewController: UIViewController {
    
    private var inventoryVC: InventoryViewController!
    private var detailVC: DetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInventoryVC()
    }
    
    private func configureInventoryVC() {
        inventoryVC = InventoryViewController()
        add(child: inventoryVC)
        self.view.addSubview(inventoryVC.view)
    }
    
    func showDetailViewController(weaponSection: Int, weaponIndex: Int) {
        if detailVC == nil {
            let xOffset: CGFloat = 10
            let width  = self.view.bounds.width - 2 * xOffset
            let height = self.view.bounds.height / 1.5
            detailVC = DetailViewController(mainViewFrame: CGRect(x: xOffset,
                                                                  y: (self.view.bounds.height - height) / 2,
                                                                  width: width,
                                                                  height: height))
            
            add(child: detailVC)
            detailVC.delegate = inventoryVC
        }
        
        // Animating view appereance
        UIView.animateViewAppereance(appearingView: detailVC.view, disappearingView: inventoryVC.view, mainView: self.view)
        detailVC.setIndexPath(weaponSection: weaponSection, weaponIndex: weaponIndex)
    }
    
    func hideDetailViewController() {
        UIView.animateViewDisappearance(disappearingView: detailVC.view, appearingView: inventoryVC.view)
    }
}

extension ContainerViewController {
    
    func add(child: UIViewController) {
        self.addChild(child)
        child.didMove(toParent: self)
    }
}


extension UIView {
    
    static func animateViewAppereance(appearingView: UIView, disappearingView: UIView, mainView: UIView) {
        appearingView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        mainView.insertSubview(appearingView, aboveSubview: disappearingView)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        disappearingView.alpha = 0.2
                        appearingView.transform = .identity
        },
                       completion: nil)
    }
    
    static func animateViewDisappearance(disappearingView: UIView, appearingView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            appearingView.alpha = 1
            disappearingView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { (succes) in
            disappearingView.removeFromSuperview()
        })
    }
}
