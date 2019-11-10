import UIKit


class InventoryViewController: UITableViewController {
    
    let model: [[Int]] = Array(repeating: Array(repeating: 10, count: 20), count: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .systemOrange
        tableView.register(InventoryTableViewCell.self, forCellReuseIdentifier: InventoryTableViewCell.reuseId)
    }
    
    // MARK: - Cell params
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InventoryOffset.tableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InventoryTableViewCell.reuseId,
                                                 for: indexPath) as! InventoryTableViewCell
        cell.collectionView.backgroundColor = .systemOrange
        cell.collectionView.reloadData()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InventoryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    // MARK: - header params
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Guns"
        case 1:
            return "Grenade"
        default:
            return "Nothing"
        }
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InventoryCollectionViewCell.reuseId,
                                                      for: indexPath) as! InventoryCollectionViewCell
        
        cell.weaponName = "gun"
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

