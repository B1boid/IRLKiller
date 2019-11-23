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
    
    func showDetailViewController(data: Weapon) {
        if detailVC == nil {
            let xOffset: CGFloat = 10
            let width  = self.view.bounds.width - 2 * xOffset
            let height = self.view.bounds.height / 1.5
            detailVC = DetailViewController(mainViewFrame: CGRect(x: xOffset,
                                                                      y: (self.view.bounds.height - height) / 2,
                                                                      width: width,
                                                                      height: height))
            
            add(child: detailVC)
        } else {
            self.view.insertSubview(detailVC.view, aboveSubview: inventoryVC.view)
        }
        
        detailVC.weapon = data
        
        UIView.animate(withDuration: 0.3,
                       animations: { self.inventoryVC.view.alpha = 0.5 })
    }
    
    func hideDetailViewController() {
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
