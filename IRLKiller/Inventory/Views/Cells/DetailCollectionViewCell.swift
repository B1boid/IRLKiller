import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    // Subviews
    let descriptionLabel = UILabel()
    
    let iv = UIImageView()
    
    let valueLabel = UILabel()
    
    static let reuseId = "DetailCollectionViewCell"
    
    private let cornerRadius: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iv)
        self.addSubview(valueLabel)
        self.addSubview(descriptionLabel)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        
        layoutDescriptionView()
        layoutImageView()
        layoutValueLabel()
    }
    
    private func beutifyLabel(label: UILabel, textColor: UIColor, fixHeightToMax: Bool) {
        if (fixHeightToMax) {
            label.font = UIFont.boldSystemFont(ofSize: 40)
        }
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = textColor
    }
    
    private func layoutDescriptionView() {
        let xOffset = cornerRadius / 2
        let yOffset: CGFloat = 0
        
        descriptionLabel.frame = CGRect(x: xOffset,
                                        y: yOffset,
                                        width: self.bounds.width - 2 * xOffset,
                                        height: self.bounds.height / 2)
        
        beutifyLabel(label: descriptionLabel, textColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), fixHeightToMax: true)
    }
    
    private func layoutImageView() {
        let xOffset: CGFloat = 0
        let yOffset = descriptionLabel.frame.maxY
        
        iv.frame = CGRect(x: xOffset,
                          y: yOffset,
                          width: self.bounds.width - 2 * xOffset,
                          height: 0)
        
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
    }
    
    private func layoutValueLabel() {
        let xOffset = cornerRadius / 2
        let yOffset = iv.frame.maxY
        
        valueLabel.frame = CGRect(x: xOffset,
                                  y: yOffset,
                                  width: self.bounds.width - 2 * xOffset,
                                  height: self.bounds.height / 2)
        
        beutifyLabel(label: valueLabel, textColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), fixHeightToMax: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
