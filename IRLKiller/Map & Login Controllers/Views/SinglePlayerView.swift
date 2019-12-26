import UIKit

class SinglePlayerView: UIView {
    
    let playerNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    let ratingChangeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .green
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
        self.addSubview(playerNameLabel)
        self.addSubview(ratingChangeLabel)
    }
    
    private func setupMainView() {
        print("SINGLE")
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        let w = self.bounds.width
        let h = self.bounds.height
        let xOffset: CGFloat = 6
        let yOffset: CGFloat = 6
        playerNameLabel.frame = CGRect(x: xOffset,
                                       y: yOffset,
                                       width: w - 2 * xOffset,
                                       height: h / 3 - yOffset)
        
        ratingChangeLabel.frame = CGRect(x: xOffset,
                                         y: playerNameLabel.frame.maxY,
                                         width: w - 2 * xOffset,
                                         height: h - playerNameLabel.frame.maxY)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
