import UIKit
import Lottie

class RewardView: UIView {
    
    let killerView = SinglePlayerView()
    let victimView = SinglePlayerView()
    let rewardAnimationView = AnimationView(name: "reward")
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 40)
        button.titleLabel?.textColor = .black
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
        self.addSubview(killerView)
        self.addSubview(victimView)
        self.addSubview(rewardAnimationView)
        self.addSubview(closeButton)
        setupRewardAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlayersChange()
        rewardAnimationView.frame = CGRect(x: 0,
                                           y: killerView.frame.maxY,
                                           width: self.bounds.width,
                                           height: self.bounds.height / 3)
        
        let buttonSide = self.bounds.height / 4 - 8
        closeButton.frame = CGRect(x: (self.bounds.width - buttonSide) / 2,
                                   y: rewardAnimationView.frame.maxY + 8,
                                   width: buttonSide,
                                   height: buttonSide)
    }
    
    private func setupRewardAnimation() {
        rewardAnimationView.loopMode = .loop
        rewardAnimationView.contentMode = .scaleAspectFit
        rewardAnimationView.play()
    }
    
    private func setupMainView() {
        self.backgroundColor = #colorLiteral(red: 0.8656491637, green: 0.2913296521, blue: 0.3646270633, alpha: 1)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
    }
    
    private func layoutPlayersChange() {
        let w = self.bounds.width
        let h = self.bounds.height
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 10
        killerView.frame = CGRect(x: xOffset, y: yOffset, width: w / 2 - 2 * xOffset, height: h / 3)
        victimView.frame = CGRect(x: w / 2 + xOffset, y: yOffset, width: w / 2 - 2 * xOffset, height: h / 3)
    }
    
    @objc
    private func closeButtonTapped() {
        UIView.animate(withDuration: 0.2,
                       animations: { self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) },
                       completion: { (succes) in self.removeFromSuperview() })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    
    static func getChangeRatingColor(delta: Int) -> UIColor {
        if (delta >= 0) {
            return .green
        }
        return .red
    }
}
