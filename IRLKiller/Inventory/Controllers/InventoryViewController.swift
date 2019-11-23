import UIKit

// MARK:- CollectionViewReloadDataDelegate
// Сделан для того, чтобы после выбора оружия collectionView обновился, чтобы не обновлять все время
protocol CollectionViewReloadDataDelegate {
    func reloadDataInCollectionView(for indexPath: IndexPath)
}

class InventoryViewController: UITableViewController {
    
    private let weaponData = WeaponData.shared
    
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
        
        cell.collectionView.backgroundColor = tableView.backgroundColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("Table view will display \(Weapons.allCases[indexPath.section].rawValue) \n -------------------- \n")
        guard let tableViewCell = cell as? InventoryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    // MARK:- tableView header params
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return InventoryConstants.headerViewHeight
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Weapons.allCases[section].rawValue.capitalized
    }
    
    // MARK:- Change header colors
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont(name: "Kefa", size: headerView.bounds.height / 1.25)
                        
            let customColorView = UIView()
            customColorView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            headerView.backgroundView = customColorView
        }
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK:- collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = Weapons.allCases[collectionView.tag].rawValue
        guard let values = weaponData.items[key] else { return 1 }
        return values.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InventoryCollectionViewCell.reuseId,
                                                      for: indexPath) as! InventoryCollectionViewCell
        
        if (indexPath.row == 0) {
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = InventoryCollectionViewCell.standartColor
        }
        
        let weaponType = Weapons.allCases[collectionView.tag].rawValue
        guard let data = weaponData.getWeapon(for: weaponType, index: indexPath.row) else { return cell }
        cell.weaponName = data.name
        cell.descriptionText = "Nice gun"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parentVC = self.parent as! ContainerViewController
        let section = collectionView.tag
        let indexInSection = indexPath.row
        parentVC.showDetailViewController(weaponSection: section, weaponIndex: indexInSection)
    }
    
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        // Здесь происходит обновление после reloadData()
//        print("Collection view display: \(Weapons.allCases[collectionView.tag].rawValue) | \(indexPath.row + 1)")
//    }
}

extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return InventoryConstants.collectionViewCellSize }
    
}


// MARK:- Delegate extension
extension InventoryViewController: CollectionViewReloadDataDelegate {
    
    func reloadDataInCollectionView(for indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! InventoryTableViewCell
        print("reload data")
        cell.collectionView.reloadData()
    }
}
