import UIKit

class InventoryViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        tableView.register(InventoryTableViewCell.self, forCellReuseIdentifier: InventoryTableViewCell.reuseId)
    }
    
    // MARK:- tableView cell params
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Weapons.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InventoryConstants.tableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InventoryTableViewCell.reuseId,
                                                 for: indexPath) as! InventoryTableViewCell
        cell.collectionView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        cell.collectionView.reloadData()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InventoryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    // MARK:- tableView header params
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Weapons.allCases[section].rawValue.capitalized
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            let customColorView = UIView()
            customColorView.backgroundColor = #colorLiteral(red: 0.07484105974, green: 0.5732269883, blue: 0.8167666793, alpha: 1)
            headerView.backgroundView = customColorView
        }
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK:- collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = Weapons.allCases[collectionView.tag].rawValue
        guard let values = weaponItems[key] else { return 0 }
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InventoryCollectionViewCell.reuseId,
                                                      for: indexPath) as! InventoryCollectionViewCell
        
        cell.weaponName = "gun"
        cell.descriptionText = "Nice gun\nYou are Welcome to play"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parentVC = self.parent as! ContainerViewController
        parentVC.showDetailViewController()
    }
}

extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return InventoryConstants.collectionViewCellSize }
    
}


