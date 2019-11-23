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
        
        detailVC.view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        view.insertSubview(detailVC.view, aboveSubview: inventoryVC.view)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                self.inventoryVC.view.alpha = 0.2
                self.detailVC.view.transform = .identity
        },
                       completion: nil)

        detailVC.setIndexPath(weaponSection: weaponSection, weaponIndex: weaponIndex)
    
    }
    
    func hideDetailViewController() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.inventoryVC.view.alpha = 1
            self.detailVC.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { (succes) in
            self.detailVC.view.removeFromSuperview()
        })
    }
}


extension ContainerViewController {
    
    func add(child: UIViewController) {
        self.addChild(child)
        child.didMove(toParent: self)
    }
}
