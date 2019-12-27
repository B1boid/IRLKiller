//
//  AfterShootView.swift
//  IRLKiller
//
//  Created by Daniil Korolev on 26.12.2019.
//  Copyright © 2019 Aleksandr Vorobev. All rights reserved.
//

import UIKit

class ShotAlertView: UIView {
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
        self.addSubview(alertLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = 10
        alertLabel.frame = CGRect(x: xOffset,
                                       y: yOffset,
                                       width: self.bounds.width - 2 * xOffset,
                                       height: self.bounds.height - 2 * yOffset)
    }
    
    private func setupMainView() {
        self.backgroundColor = #colorLiteral(red: 0.8656491637, green: 0.2913296521, blue: 0.3646270633, alpha: 1)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
