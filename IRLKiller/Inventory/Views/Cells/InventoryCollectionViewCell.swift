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
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.backgroundColor = .clear
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
                weaponNameLabel.text = name.capitalized
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = InventoryCollectionViewCell.standartBorderColor
        self.layer.borderColor = InventoryCollectionViewCell.standartBorderColor.cgColor
        self.layer.borderWidth = 4
        self.addSubview(weaponNameLabel)
        self.addSubview(weaponIV)
        self.addSubview(descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func beutifyLabelText(label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCornerRadius()
        
        let cornerOffset = InventoryConstants.cornerRadius / 2
        
        layoutNameLabel(cornerOffset: cornerOffset)
        layoutImageView()
        layoutDescriptionLabel(cornerOffset: cornerOffset)
    }
    
    private func setupCornerRadius() {
        weaponIV.layer.cornerRadius = InventoryConstants.cornerRadius
        self.layer.cornerRadius = InventoryConstants.cornerRadius
    }
    
    private func layoutNameLabel(cornerOffset: CGFloat) {
        weaponNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive                       = true
        weaponNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cornerOffset).isActive    = true
        weaponNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -cornerOffset).isActive = true
        weaponNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2 / 9).isActive           = true
        
        beutifyLabelText(label: weaponNameLabel)
    }
    
    private func layoutImageView() {
        weaponIV.contentMode = .scaleAspectFit
        
        weaponIV.topAnchor.constraint(equalTo: weaponNameLabel.bottomAnchor, constant: 5).isActive               = true
        weaponIV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive                    = true
        weaponIV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive                 = true
        weaponIV.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 5 / 9).isActive                 = true
    }
    
    
    private func layoutDescriptionLabel(cornerOffset: CGFloat) {
        descriptionLabel.topAnchor.constraint(equalTo: weaponIV.bottomAnchor, constant: 5).isActive                = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cornerOffset).isActive    = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -cornerOffset).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -cornerOffset).isActive     = true
        
        beutifyLabelText(label: descriptionLabel)
    }
}

extension InventoryCollectionViewCell {
    
    static let standartBorderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let chooseBorderColor = UIColor.white
    
}
