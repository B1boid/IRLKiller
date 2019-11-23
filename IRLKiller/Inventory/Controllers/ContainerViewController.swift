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
        } else {
            self.view.insertSubview(detailVC.view, aboveSubview: inventoryVC.view)
        }
        detailVC.setIndexPath(weaponSection: weaponSection, weaponIndex: weaponIndex)
            
        inventoryVC.view.removeFromSuperview()
    }
    
    func hideDetailViewController() {
        self.view.insertSubview(inventoryVC.view, aboveSubview: detailVC.view)
        detailVC.view.removeFromSuperview()
        self.inventoryVC.view.alpha = 1
    }
}


extension ContainerViewController {
    
    func add(child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

//
//extension UIImage {
//    static var reload: UIImage {
//        return UIImage("sdfg")
//    }
//}
