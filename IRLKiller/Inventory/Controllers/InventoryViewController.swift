import UIKit

// MARK:- CollectionViewReloadDataDelegate
// Сделан для того, чтобы после выбора оружия collectionView обновился, чтобы не обновлять все время
protocol CollectionViewReloadDataDelegate {
    func reloadDataInCollectionView(for indexPath: IndexPath)
}

class InventoryViewController: UITableViewController {
    
    private let weaponData = WeaponModel.shared
    private var statusBarColorChangeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = InventoryViewController.bgColor
        tableView.showsVerticalScrollIndicator = false
        tableView.shouldScrollSectionHeaders = true
        tableView.register(InventoryTableViewCell.self, forCellReuseIdentifier: InventoryTableViewCell.reuseId)
    }
    
    // MARK:- tableView cell attributes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return WeaponTypes.allCases.count
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
    
    // MARK:- Set delegeta because of dequeueResuableCell (collection view doesn't update cells)
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InventoryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forSection: indexPath.section)
    }
    
    // MARK:- tableView header attributes
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return InventoryConstants.tableViewCellHeight / 8
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return WeaponTypes.allCases[section].rawValue.capitalized
    }
    
    // MARK:- Change header colors
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = #colorLiteral(red: 0.07587141544, green: 0.1329714358, blue: 0.2183612585, alpha: 1)
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont(name: "Kefa", size: headerView.bounds.height / 1.25)
            
            let customColorView = UIView()
            customColorView.backgroundColor = InventoryViewController.headerColor
            headerView.backgroundView = customColorView
        }
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK:- collectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = WeaponTypes.allCases[collectionView.tag].rawValue
        guard let values = weaponData.items[key] else { return 1 }
        return values.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InventoryCollectionViewCell.reuseId,
                                                      for: indexPath) as! InventoryCollectionViewCell
        
        let weaponType = WeaponTypes.allCases[collectionView.tag].rawValue
        guard let weapon = weaponData.getWeapon(for: weaponType, index: indexPath.row) else { return cell }
        cell.weaponName = weapon.name
        cell.descriptionText = "Nice gun"
    
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parentVC = self.parent as! ContainerViewController
        let section = collectionView.tag
        let indexInSection = indexPath.row
        parentVC.showDetailViewController(weaponSection: section, weaponIndex: indexInSection)
    }
}

extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return InventoryConstants.collectionViewCellSize }
    
}


// MARK:- Delegate extension & colors constants
extension InventoryViewController: CollectionViewReloadDataDelegate {
    
    func reloadDataInCollectionView(for indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! InventoryTableViewCell
        cell.collectionView.reloadData()
    }
    
    static let bgColor = #colorLiteral(red: 0.2092410028, green: 0.3064872622, blue: 0.4088295698, alpha: 1)
    static let weaponCellColor = #colorLiteral(red: 0.5943054557, green: 0.8013091683, blue: 0.8286970258, alpha: 1)
    static let headerColor = #colorLiteral(red: 0.9223738313, green: 0.9414827228, blue: 0.9628887773, alpha: 1)
}

extension UITableView {
    
    static let shouldScrollSectionHeadersDummyViewHeight = CGFloat(100)
    
    var shouldScrollSectionHeaders: Bool {
        set {
            if newValue {
                tableHeaderView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: bounds.size.width,
                                                       height: UITableView.shouldScrollSectionHeadersDummyViewHeight))
                
                // Говорим что наш контент(ячейки) не будет(будут) налезать на headerView
                contentInset = UIEdgeInsets(top: (-1) * UITableView.shouldScrollSectionHeadersDummyViewHeight,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
            } else {
                tableHeaderView = nil
                contentInset = .zero
            }
        }
        get {
            return tableHeaderView != nil && contentInset.top == UITableView.shouldScrollSectionHeadersDummyViewHeight
        }
    }
}
