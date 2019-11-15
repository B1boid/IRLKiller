import UIKit

class DetailViewController: UIViewController {
    
    // Buttons
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeDetailViewController), for: .touchUpInside)
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
    private lazy var weaponImage: UIImageView = {
        let im = UIImageView()
     //   im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        im.clipsToBounds = true
        return im
    }()
    
    
    // Description views (params for weapon)
    let reloadDV = DescriptionWeaponView()
    let distanceDV = DescriptionWeaponView()
    let damageDV = DescriptionWeaponView()
    let capacityDV = DescriptionWeaponView()
    
    var descriptionViews: [DescriptionWeaponView] = []
    
    var weapon: Weapon! {
        didSet {
            reloadData(data: weapon)
        }
    }
    
    // Constans
    private let cornerRadius: CGFloat = 10
    
    init(accesoryViewFrame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = accesoryViewFrame

        view.addSubview(closeButton)
        view.addSubview(chooseButton)
        view.addSubview(nameLabel)
        view.addSubview(weaponImage)
        
        descriptionViews = [reloadDV, distanceDV, damageDV, capacityDV]
        descriptionViews.forEach { self.view.addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        self.view.layer.cornerRadius = cornerRadius
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layoutNameLabel()
        layoutWeaponImage()
        layoutDescriptionViews()
        layoutButtons()
    }
    
    // MARK:- Layout functions
    private func layoutNameLabel() {
        nameLabel.frame = CGRect(x: cornerRadius,
                                 y: cornerRadius,
                                 width: self.view.bounds.width - 2 * cornerRadius,
                                 height: self.view.bounds.height / 7)
    }
    
    private func layoutWeaponImage() {
        let xOffset: CGFloat = 20
        let yOffset = nameLabel.frame.maxY + 2
        
        weaponImage.frame = CGRect(x: xOffset,
                                   y: yOffset,
                                   width: self.view.bounds.width - 2 * xOffset,
                                   height: self.view.bounds.height * (2 / 5))
    }
    
    private func layoutButtons() {
        closeButton.setImage(UIImage(named: "closeButton"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -cornerRadius).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: cornerRadius).isActive            = true
        closeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 10).isActive          = true
        closeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 10).isActive            = true
        
        chooseButton.backgroundColor = .blue
        chooseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -cornerRadius).isActive    = true
        chooseButton.topAnchor.constraint(equalTo: reloadDV.bottomAnchor, constant: 10).isActive              = true
        chooseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 5).isActive            = true
        chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                           = true
    }
    
    private func layoutDescriptionViews() {
        let cnt = CGFloat(descriptionViews.count)
        
        let widthForDescriptionView = (self.view.bounds.width * 4 / 5) / cnt
        let heightForDescriptionView = self.view.bounds.height / 5
        
        let xOffset = (self.view.bounds.width - cnt * widthForDescriptionView) / (cnt + 1)
        let yOffset = self.weaponImage.frame.maxY + 10
        
        var curOffset = xOffset
        for view in descriptionViews {
            view.frame = CGRect(x: curOffset,
                                y: yOffset,
                                width: widthForDescriptionView,
                                height: heightForDescriptionView)
            
            curOffset += xOffset
            curOffset += widthForDescriptionView
        }
    }
    
    
    // MARK:- Action functions
    private func reloadData(data: Weapon) {
        nameLabel.text = data.weaponName
        weaponImage.image = UIImage(named: data.weaponName)
        reloadDV.descriptionLabel.text   = "reload time\n" + String(data.weaponReloadTime)
        damageDV.descriptionLabel.text   = "damage\n" + String(data.weaponDamage)
        distanceDV.descriptionLabel.text = "distance\n" + String(data.weaponDistance)
        capacityDV.descriptionLabel.text = "capacity\n" + String(data.weaponCapacity)
    }
    
    @objc private func closeDetailViewController() {
        let parent = self.parent as! ContainerViewController
        parent.hideDetailViewController()
    }
}
