import UIKit

class DetailViewController: UIViewController {
    
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
        return button
    }()
    
    // Name label
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // weapon image
    private lazy var weaponImage = UIImageView()
    
    // Description views (params for weapon
    
    var weapon: Weapon! {
        didSet {
            reloadData(data: weapon)
        }
    }
    
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
            layout.minimumInteritemSpacing = CellConstants.minInteritemSpacing
            layout.sectionInset = UIEdgeInsets(top: 0,
                                               left: CellConstants.inset,
                                               bottom: 0,
                                               right: CellConstants.inset)
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
        self.view.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
        let xOffset = cornerRadius
        let yOffset = cornerRadius
        nameLabel.textColor = .white
        nameLabel.sizeToFit()
        
        nameLabel.frame = CGRect(x: xOffset,
                                 y: yOffset,
                                 width: mainView.bounds.width - 2 * xOffset,
                                 height: mainView.bounds.height / 7)
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
    
    // MARK:- Reload data
    private func reloadData(data: Weapon) {
        viewWillLayoutSubviews()
        weaponImage.image = UIImage(named: data.weaponName)!
        nameLabel.font = UIFont(name: nameLabel.font.fontName, size: 100)
        nameLabel.text = data.weaponName
        detailCollectionView.reloadData()
    }
    
    private func getPropertyByIndx(index: Int) -> (name: String, value: Float) {
        // | damage | distance | capacity | reloadTime |
        switch index {
        case 0:
            return (name: "Damage", value: weapon!.weaponDamage)
        case 1:
            return (name: "Distance", value: weapon!.weaponDamage)
        case 2:
            return (name: "Capacity", value: weapon!.weaponCapacity)
        case 3:
            return (name: "Reload time", value: weapon!.weaponReloadTime)
        default:
            return (name: "", value: 0)
        }
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
    
    private func chooseWeaponAction() {
        
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseId, for: indexPath) as! DetailCollectionViewCell
        
        cell.backgroundColor = #colorLiteral(red: 0.2891684771, green: 0.1964806318, blue: 0.3006016016, alpha: 1)
        let params = getPropertyByIndx(index: indexPath.row)
        cell.descriptionLabel.text = params.name
        cell.valueLabel.text = String(params.value)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nWidth = CellConstants.calcWidth(collectionViewWidth: collectionView.bounds.width)
        let nHeight = collectionView.bounds.height
        return CGSize(width: nWidth, height: nHeight)
    }
}

struct CellConstants {
    static let minInteritemSpacing: CGFloat = 10
    static let itemsPerRow: CGFloat = 4
    static let inset: CGFloat = 5
    
    static func calcWidth(collectionViewWidth: CGFloat) -> CGFloat {
        return (collectionViewWidth - (CellConstants.itemsPerRow - 1) * CellConstants.minInteritemSpacing - 2 * CellConstants.inset) / CellConstants.itemsPerRow
    }
}


extension UIImage {
    static let shootgun = UIImage(named: "shotgun")
    static let revolver = UIImage(named: "revolver")
    static let knife = UIImage(named: "knife")
    static let basic = UIImage(named: "basic")
}
