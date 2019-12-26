import UIKit


class DetailViewController: UIViewController {
    
    private let weaponModel = WeaponModel.shared
    var delegate: CollectionViewReloadDataDelegate?
    
    private var curWeapon: Weapon!
    
    private var weaponKey: String!
    private var weaponSection: Int!
    private var weaponIndex: Int!
    
    // MAIN VIEW
    private var mainView: UIView!
    private var tapRecoznizer: UITapGestureRecognizer!
    private var detailCollectionView: UICollectionView!
    
    // Buttons
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(closeDetailViewControllerAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set this weapon by default", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = #colorLiteral(red: 0.4193970859, green: 0.6569570899, blue: 0.6623717546, alpha: 1)
        button.addTarget(self, action: #selector(chooseWeapon), for: .touchUpInside)
        return button
    }()
    
    // Name label
    private lazy var nameLabel = UILabel()
    
    // weapon image
    private lazy var weaponImage = UIImageView()
    
    // Constans
    private let cornerRadius: CGFloat = 10
    
    init(mainViewFrame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        
        setupRecognizer()
        setupDetailCollectionView()
        
        mainView = UIView(frame: mainViewFrame)
        self.view.addSubview(mainView)
        
        mainView.addSubview(closeButton)
        mainView.addSubview(chooseButton)
        mainView.addSubview(nameLabel)
        mainView.addSubview(detailCollectionView)
        mainView.addSubview(weaponImage)
    }
    
    private func setupRecognizer() {
        tapRecoznizer = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        self.view.addGestureRecognizer(tapRecoznizer)
    }
    
    private func setupDetailCollectionView() {
        
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = AttributeCellConstants.minInteritemSpacing
            layout.sectionInset = UIEdgeInsets(top: 0,
                                               left: AttributeCellConstants.inset,
                                               bottom: 0,
                                               right: AttributeCellConstants.inset)
            return layout
        }()
        
        detailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        detailCollectionView.register(DetailCollectionViewCell.self,
                                      forCellWithReuseIdentifier: DetailCollectionViewCell.reuseId)
        
        detailCollectionView.dataSource = self
        detailCollectionView.delegate = self
        detailCollectionView.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        designMainView()
        
        layoutNameLabel()
        layoutWeaponImage()
        layoutDetailCollectionView()
        layoutCloseButton()
        layoutChooseButton()
    }
    
    
    // MARK:- Design main view
    private func designMainView() {
        mainView.layer.cornerRadius = cornerRadius
        mainView.backgroundColor = #colorLiteral(red: 0.1165478751, green: 0.301977098, blue: 0.3084881604, alpha: 1)
        mainView.layer.borderColor = #colorLiteral(red: 0.4340616167, green: 0.727235496, blue: 0.5600054264, alpha: 1)
        mainView.layer.borderWidth = 4
        detailCollectionView.backgroundColor = mainView.backgroundColor
    }
    
    // MARK:- Layout functions
    private func layoutNameLabel() {
        let xOffset = cornerRadius + mainView.bounds.width / 10
        let yOffset = cornerRadius

        nameLabel.frame = CGRect(x: xOffset,
                                 y: yOffset,
                                 width: mainView.bounds.width - 2 * xOffset,
                                 height: mainView.bounds.height * (15 / 100))
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 60)
        nameLabel.textColor = .white
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func layoutWeaponImage() {
        weaponImage.backgroundColor = #colorLiteral(red: 0.8981302381, green: 0.8737419248, blue: 0.8740172982, alpha: 1)
        weaponImage.layer.cornerRadius = 10
        weaponImage.contentMode = .scaleAspectFit
        
        let xOffset: CGFloat = 2 * cornerRadius
        let yOffset = nameLabel.frame.maxY + 2
        
        weaponImage.frame = CGRect(x: xOffset,
                                   y: yOffset,
                                   width: mainView.bounds.width - 2 * xOffset,
                                   height: mainView.bounds.height * (37 / 100))
    }
    
    private func layoutDetailCollectionView() {
        let xOffset: CGFloat = 0
        let yOffset = weaponImage.frame.maxY + 10
        
        detailCollectionView.frame = CGRect(x: xOffset,
                                            y: yOffset,
                                            width: mainView.bounds.width - 2 * xOffset,
                                            height: mainView.bounds.height * (20 / 100))
    }
    
    private func layoutCloseButton() {
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -cornerRadius).isActive = true
        closeButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: cornerRadius).isActive            = true
        closeButton.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1 / 10).isActive          = true
        closeButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1 / 10).isActive            = true
    }
    
    private func layoutChooseButton() {
        chooseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        chooseButton.layer.cornerRadius = 10
        
        chooseButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -cornerRadius).isActive    = true
        chooseButton.topAnchor.constraint(equalTo: detailCollectionView.bottomAnchor, constant: 10).isActive      = true
        chooseButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 2 / 5).isActive            = true
        chooseButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive                           = true
        
        chooseButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    
    // MARK:- Set weapon index path
    func setIndexPath(weaponSection: Int, weaponIndex: Int) {
        self.weaponSection = weaponSection
        self.weaponIndex = weaponIndex
        weaponKey = WeaponTypes.allCases[weaponSection].rawValue
        
        setWeaponAttributes()
    }
    
    // MARK:- Set attributes
    private func setWeaponAttributes() {
        guard let values = weaponModel.items[weaponKey] else { return }
        curWeapon = values[weaponIndex]
        detailCollectionView.reloadData()
       
        nameLabel.text = curWeapon.name.capitalized
        weaponImage.image = UIImage.getWeaponImage(name: curWeapon.name)
    }
    
    
    // MARK:- Choose weapon action
    @objc private func chooseWeapon() {
        
        // Set element to the first position //
        weaponModel.items[weaponKey]?.swapAt(0, weaponIndex)
        
        let indexPath = IndexPath(row: 0, section: weaponSection)
        UserDefaults.standard.saveWeaponSection(for: indexPath)
        WeaponModel.defaultWeapon = UserDefaults.standard.getDefaultWeapon()
        
        // Call this method because we want collectiovView for special row to update
        delegate?.reloadDataInCollectionView(for: indexPath)
        closeDetailViewControllerAction()
    }
    
    // MARK:- TapGestrureRecognizer action
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let pointOfTap = sender.location(in: view)
            guard mainView.frame.contains(pointOfTap) else {
                closeDetailViewControllerAction()
                return
            }
        default:
            break
        }
    }
    
    @objc private func closeDetailViewControllerAction() {
        let parent = self.parent as! ContainerViewController
        parent.hideDetailViewController()
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeaponAttributes.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseId, for: indexPath) as! DetailCollectionViewCell
        
        cell.backgroundColor = #colorLiteral(red: 0.2044287026, green: 0.4524510503, blue: 0.4624926448, alpha: 1)
        let attribute = WeaponAttributes.allCases[indexPath.row]
        // Look enum down here (cases in enum is properties to display)
        let atrributeValue = attribute.getValue(weapon: curWeapon)
        
        cell.descriptionLabel.text = attribute.rawValue.capitalized
        cell.valueLabel.text = atrributeValue
        return cell
    }
}


// MARK:- Weapon attributes enum
private enum WeaponAttributes: String, CaseIterable {
    // cases shoud be written with underscore if they have more than one word -> than names converted by splitted with "_"
    case damage
    case reload
    case distance
    case capacity
    
    func getValue(weapon: Weapon) -> String {
        switch self {
        case .damage:
            return "\(weapon.damage) points"
        case .reload:
            return "\(weapon.reloadTime) sec"
        case .distance:
            return "\(weapon.distance) m"
        case .capacity:
            return "\(weapon.capacity) shoots"
        }
    }
}


// MARK:- AttributeCellConstants
private struct AttributeCellConstants {
    static let minInteritemSpacing: CGFloat = 10
    static let itemsPerRow: CGFloat = 4
    static let inset: CGFloat = 10
    
    static func calculateWidth(collectionViewWidth: CGFloat) -> CGFloat {
        return (collectionViewWidth - (AttributeCellConstants.itemsPerRow - 1) * AttributeCellConstants.minInteritemSpacing
            - 2 * AttributeCellConstants.inset) / AttributeCellConstants.itemsPerRow
    }
}



extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nWidth = AttributeCellConstants.calculateWidth(collectionViewWidth: collectionView.bounds.width)
        let nHeight = collectionView.bounds.height
        return CGSize(width: nWidth, height: nHeight)
    }
}



extension UIImage {
    
    static let shootgun = UIImage(named: "shootgun")!
    static let revolver = UIImage(named: "revolver")!
    static let knife = UIImage(named: "knife")!
    static let basic = UIImage(named: "basic")!
    
    static func getWeaponImage(name: String) -> UIImage {
        switch name {
        case "shootgun":
            return UIImage.shootgun
        case "revolver":
            return UIImage.revolver
        case "knife":
            return UIImage.knife
        case "basic":
            return UIImage.basic
        default:
            return UIImage.basic
        }
    }
}
