import UIKit
import Lottie

class CoolDownNotificationView: UIView {
    
    private let animationView = AnimationView(name: "cooldown")
    
    private let msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Overheat! Wait for your weapon to cool down"
        
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(frame: CGRect, timeLeft: UInt) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.addSubview(animationView)
        animationView.addSubview(msgLabel)
        animationView.addSubview(timeLeftLabel)
        timeLeftLabel.text = "Time left: \(timeLeft) seconds"
        self.backgroundColor = #colorLiteral(red: 0.1882152259, green: 0.1882481873, blue: 0.1882079244, alpha: 1)
        setupAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = self.bounds
        let labelsHeight = animationView.bounds.height / 3
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 5
        msgLabel.frame = CGRect(x: xOffset,
                                     y: yOffset,
                                     width: animationView.bounds.width - 2 * xOffset,
                                     height: labelsHeight - yOffset)
        
        timeLeftLabel.frame = CGRect(x: xOffset,
                                     y: labelsHeight * 2,
                                     width: animationView.bounds.width - 2 * xOffset,
                                     height: labelsHeight)
    }
    
    
    private func setupAnimation() {
        animationView.animationSpeed = 2.0
        animationView.loopMode = .loop
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
