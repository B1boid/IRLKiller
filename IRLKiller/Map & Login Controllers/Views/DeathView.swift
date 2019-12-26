import UIKit

class DeathView: UIView {
    
    private let deadLabel: UILabel = {
        let label = UILabel()
        label.text = "You DEAD!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let rebornLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private var timeToRebornInSeconds: UInt = 60 * 5
    
    init(frame: CGRect, timeToReborn: UInt) {
        super.init(frame: frame)
        self.timeToRebornInSeconds = timeToReborn
        setupMainView()
        self.addSubview(deadLabel)
        self.addSubview(rebornLabel)
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(redrawTime(timer: )),
                             userInfo: nil,
                             repeats: true)
    }
    
    private func setupMainView() {
        self.backgroundColor = #colorLiteral(red: 0.8656491637, green: 0.2913296521, blue: 0.3646270633, alpha: 1)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.bounds.width
        let h = self.bounds.height
        
        deadLabel.frame = CGRect(x: 0,
                                 y: 10,
                                 width: w,
                                 height: h / 4)
        
        rebornLabel.frame = CGRect(x: 0,
                                   y: deadLabel.bounds.maxY,
                                   width: w,
                                   height: h - deadLabel.bounds.maxY)
        
    }
    
    @objc
    private func redrawTime(timer: Timer) {
        guard timeToRebornInSeconds != 0 else {
            self.removeFromSuperview()
            return
        }
        timeToRebornInSeconds -= 1
        let mins = timeToRebornInSeconds / 60
        let second = timeToRebornInSeconds % 60
        if (mins == 0) {
            rebornLabel.text = "You wil be reborn in" + "\n" + "\(second) second(s)"
        } else {
            rebornLabel.text = "You wil be reborn in" + "\n" + "\(mins) minute(s) : \(second) second(s)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
