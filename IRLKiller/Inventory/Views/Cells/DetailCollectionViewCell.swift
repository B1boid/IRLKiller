import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    // Subviews
    var descriptionLabel = UILabel()
    
    var iv = UIImageView()
    
    var valueLabel = UILabel()
    
    static let reuseId = "DetailCollectionViewCell"
    
    private let cornerRadius: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(iv)
        self.addSubview(valueLabel)
        self.addSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        
        layoutDescriptionView()
        layoutImageView()
        layoutValueLabel()
    }
    
    private func beutifyLabel(label: UILabel) {
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
    }
    
    private func layoutDescriptionView() {
        let xOffset = cornerRadius / 2
        let yOffset: CGFloat = 0
        
        descriptionLabel.frame = CGRect(x: xOffset,
                                        y: yOffset,
                                        width: self.bounds.width - 2 * xOffset,
                                        height: self.bounds.height / 3)
        
        beutifyLabel(label: descriptionLabel)
    }
    
    private func layoutImageView() {
        let xOffset: CGFloat = 0
        let yOffset = descriptionLabel.frame.maxY
        
        iv.frame = CGRect(x: xOffset,
                          y: yOffset,
                          width: self.bounds.width - 2 * xOffset,
                          height: self.bounds.height / 3)
        
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
    }
    
    private func layoutValueLabel() {
        let xOffset = cornerRadius / 2
        let yOffset = iv.frame.maxY
        
        valueLabel.frame = CGRect(x: xOffset,
                                  y: yOffset,
                                  width: self.bounds.width - 2 * xOffset,
                                  height: self.bounds.height / 3)
        
        beutifyLabel(label: valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
