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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var descriptionText: String? {
        didSet {
            if let text = descriptionText {
                descriptionLabel.text = text
            }
        }
    }
    
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
        self.addSubview(descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beutifyLabelText(label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.sizeToFit()
        label.numberOfLines = 3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        beutifyLabelText(label: weaponNameLabel)
        beutifyLabelText(label: descriptionLabel)
        
        setupCornerRadius()
        layourConstrains(cornerRadius: InventoryOffset.cornerRadius)
    }
    
    func setupCornerRadius() {
        weaponIV.clipsToBounds = true
        weaponIV.layer.cornerRadius = InventoryOffset.cornerRadius
        self.layer.cornerRadius = InventoryOffset.cornerRadius
    }
    
    func layourConstrains(cornerRadius: CGFloat) {
        weaponNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 1).isActive = true
        weaponNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cornerRadius / 2).isActive = true
        weaponNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -cornerRadius / 2).isActive = true
        weaponNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1 / 9).isActive = true
        
        weaponIV.topAnchor.constraint(equalTo: weaponNameLabel.bottomAnchor, constant: 2).isActive = true
        weaponIV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        weaponIV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        weaponIV.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 6 / 9).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: weaponIV.bottomAnchor, constant: 1).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cornerRadius / 2).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -cornerRadius / 2).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -cornerRadius / 2).isActive = true
    }
}
