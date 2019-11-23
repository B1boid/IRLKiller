import UIKit


class DetailViewController: UIViewController {
    
    private let weaponData = WeaponData.shared
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
        button.addTarget(self, action: #selector(closeDetailViewControllerAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        print("Start layout")
        mainView.layer.cornerRadius = cornerRadius
        mainView.backgroundColor = #colorLiteral(red: 0.1516100168, green: 0.211818397, blue: 0.1466259658, alpha: 1)
        detailCollectionView.backgroundColor = mainView.backgroundColor
        
        layoutNameLabel()
        layoutWeaponImage()
        layoutDetailCollectionView()
        layoutCloseButton()
        layoutChooseButton()
    }
    
    // MARK:- Layout functions
    private func layoutNameLabel() {
        print("layout name label")
        let xOffset = cornerRadius
        let yOffset = cornerRadius
        
        nameLabel.frame = CGRect(x: xOffset,
                                 y: yOffset,
                                 width: mainView.bounds.width - 2 * xOffset,
                                 height: mainView.bounds.height / 7)
        
        nameLabel.textColor = .white
        nameLabel.clipsToBounds = true
        print(nameLabel.frame)
        print(nameLabel.text!)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 50)
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func layoutWeaponImage() {
        weaponImage.backgroundColor = #colorLiteral(red: 0.8300592303, green: 0.8200153708, blue: 0.7629007101, alpha: 1)
        weaponImage.layer.cornerRadius = 10
        weaponImage.contentMode = .scaleAspectFit
        
        let xOffset: CGFloat = 20
        let yOffset = nameLabel.frame.maxY + 2
        
        weaponImage.frame = CGRect(x: xOffset,
                                   y: yOffset,
                                   width: mainView.bounds.width - 2 * xOffset,
                                   height: mainView.bounds.height * (2 / 5))
        
        print(weaponImage.frame)
    }
    
    private func layoutDetailCollectionView() {
        let xOffset: CGFloat = 0
        let yOffset = weaponImage.frame.maxY + 10
        
        detailCollectionView.frame = CGRect(x: xOffset,
                                            y: yOffset,
                                            width: mainView.bounds.width - 2 * xOffset,
                                            height: mainView.bounds.height * (7 / 35))
    }
    
    private func layoutCloseButton() {
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        
        closeButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -cornerRadius).isActive = true
        closeButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: cornerRadius).isActive            = true
        closeButton.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 1 / 10).isActive          = true
        closeButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1 / 10).isActive            = true
    }
    
    private func layoutChooseButton() {
        chooseButton.backgroundColor = #colorLiteral(red: 0.2891684771, green: 0.1964806318, blue: 0.3006016016, alpha: 1)
        chooseButton.setTitle("Choose this weapon", for: .normal)
        chooseButton.setTitleColor(.white, for: .normal)
        chooseButton.titleLabel?.adjustsFontSizeToFitWidth = true
        chooseButton.layer.cornerRadius = 10
        
        chooseButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -cornerRadius).isActive    = true
        chooseButton.topAnchor.constraint(equalTo: detailCollectionView.bottomAnchor, constant: 10).isActive      = true
        chooseButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 2 / 5).isActive            = true
        chooseButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive                           = true
    }
    
    
    
    // MARK:- Set weapon index path
    func setIndexPath(weaponSection: Int, weaponIndex: Int) {
        self.weaponSection = weaponSection
        self.weaponIndex = weaponIndex
        weaponKey = Weapons.allCases[weaponSection].rawValue
        
        setWeaponAttributes()
    }
    
    // MARK:- Set attributes
    private func setWeaponAttributes() {
        guard let values = weaponData.items[weaponKey] else { return }
        curWeapon = values[weaponIndex]
        
        nameLabel.text = curWeapon.name
        weaponImage.image = UIImage.init(named: curWeapon.name)
    }
    
    
    // MARK:- Choose weapon action
    @objc private func chooseWeapon() {
        // Set element to the first position //
        weaponData.items[weaponKey]?.swapAt(0, weaponIndex)
        
        let indexPath = IndexPath(row: 0, section: weaponSection)
        
        delegate?.reloadDataInCollectionView(for: indexPath)
        closeDetailViewControllerAction()
    }
        
    // MARK:- TapGestrureRecognizer action
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let pointOfTap = sender.location(in: view)
            let xInsideCondition = (mainView.frame.minX...mainView.frame.maxX).contains(pointOfTap.x)
            let yInsideCondition = (mainView.frame.minY...mainView.frame.maxY).contains(pointOfTap.y)
            guard xInsideCondition && yInsideCondition else {
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
        
        cell.backgroundColor = #colorLiteral(red: 0.2891684771, green: 0.1964806318, blue: 0.3006016016, alpha: 1)
        let attribute = WeaponAttributes.allCases[indexPath.row]
        let attributeName = attribute.rawValue.split(separator: "_").joined(separator: " ")
        let atrributeValue = String(attribute.getValue(weapon: curWeapon))
        
        cell.descriptionLabel.text = attributeName
        cell.valueLabel.text = atrributeValue
        return cell
    }
}


// MARK:- Weapon attributes enum
enum WeaponAttributes: String, CaseIterable {
    // cases shoud be written with underscore if they have more than one word -> than names converted by splitted with "_"
    case damage
    case reload_time
    case distance
    case capacity
    
    func getValue(weapon: Weapon) -> Float {
        switch self {
        case .damage:
            return weapon.damage
        case .reload_time:
            return weapon.reloadTime
        case .distance:
            return weapon.distance
        case .capacity:
            return weapon.capacity
        }
    }
}


// MARK:- AttributeCellConstants
struct AttributeCellConstants {
    static let minInteritemSpacing: CGFloat = 10
    static let itemsPerRow: CGFloat = 4
    static let inset: CGFloat = 5
    
    static func calcWidth(collectionViewWidth: CGFloat) -> CGFloat {
        return (collectionViewWidth - (AttributeCellConstants.itemsPerRow - 1) * AttributeCellConstants.minInteritemSpacing
            - 2 * AttributeCellConstants.inset) / AttributeCellConstants.itemsPerRow
    }
}



extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nWidth = AttributeCellConstants.calcWidth(collectionViewWidth: collectionView.bounds.width)
        let nHeight = collectionView.bounds.height
        return CGSize(width: nWidth, height: nHeight)
    }
}



extension UIImage {
    static let shootgun = UIImage(named: "shotgun")
    static let revolver = UIImage(named: "revolver")
    static let knife = UIImage(named: "knife")
    static let basic = UIImage(named: "basic")
}
