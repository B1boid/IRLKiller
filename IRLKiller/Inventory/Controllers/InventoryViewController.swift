import UIKit

class InventoryViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = #colorLiteral(red: 0.6039316654, green: 1, blue: 0.5143471956, alpha: 1)
        tableView.register(InventoryTableViewCell.self, forCellReuseIdentifier: InventoryTableViewCell.reuseId)
    }
    
    // MARK: - Cell params
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Weapons.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InventoryOffset.tableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InventoryTableViewCell.reuseId,
                                                 for: indexPath) as! InventoryTableViewCell
        cell.collectionView.backgroundColor = #colorLiteral(red: 0.6039316654, green: 1, blue: 0.5143471956, alpha: 1)
        cell.collectionView.reloadData()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InventoryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
    
    // MARK: - header params
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Weapons.allCases[section].rawValue.capitalized
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            print("IN")
            headerView.backgroundView?.tintColor = .red
        }
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedItem = collectionView.cellForItem(at: indexPath) as! InventoryCollectionViewCell
        let dvc = DetailViewController()
        dvc.modalPresentationStyle = .fullScreen
        self.present(dvc, animated: true) {
            print("Presented")
        }
    }
}

extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { return InventoryOffset.collectionViewCellSize }
    
}

