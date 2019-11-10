import UIKit

class InventoryTableViewCell: UITableViewCell {
    
    static let reuseId = "InventoryTableViewCell"
    
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = InventoryOffset.minLineSpacing
            layout.itemSize = InventoryOffset.collectionViewCellSize
            
            layout.sectionInset = UIEdgeInsets(top: InventoryOffset.top,
                                               left: InventoryOffset.left,
                                               bottom: InventoryOffset.bottom,
                                               right: InventoryOffset.right)
            return layout
        }()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InventoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: InventoryCollectionViewCell.reuseId)
        
        self.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = self.bounds
    }
}

extension InventoryTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>
        (_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        
        collectionView.tag = row
        collectionView.reloadData()
    }
}