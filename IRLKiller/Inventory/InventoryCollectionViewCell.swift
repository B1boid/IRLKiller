import UIKit

class InventoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "InventoryCollectionViewCell"
    
    private lazy var weaponIV: UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    private lazy var weaponNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var infoButton: UIButton!
    private var selectButton: UIButton!
    
    var weaponName: String? {
        didSet {
            if let name = weaponName {
                weaponIV.image = UIImage(named: name)
                weaponNameLabel.text = name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(weaponNameLabel)
        self.addSubview(weaponIV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCornerRadius()
        let cornerRadius = InventoryOffset.cornerRadius
        
        weaponNameLabel.adjustsFontSizeToFitWidth = true
        weaponNameLabel.textAlignment = .center
        weaponNameLabel.sizeToFit()
        
        weaponIV.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        weaponIV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        weaponIV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        weaponIV.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3 / 4).isActive = true
        
        weaponNameLabel.topAnchor.constraint(equalTo: weaponIV.bottomAnchor, constant: -10).isActive = true
        weaponNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cornerRadius).isActive = true
        weaponNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -cornerRadius).isActive = true
        weaponNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
    }
    
    func setupCornerRadius() {
        weaponIV.clipsToBounds = true
        weaponIV.layer.cornerRadius = InventoryOffset.cornerRadius
        self.layer.cornerRadius = InventoryOffset.cornerRadius
    }
}
