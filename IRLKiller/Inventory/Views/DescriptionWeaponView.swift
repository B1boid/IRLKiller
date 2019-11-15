//
//  DescriptionWeaponView.swift
//  IRLKiller
//
//  Created by Даниил Королёв on 14.11.2019.
//  Copyright © 2019 Aleksandr Vorobev. All rights reserved.
//

import UIKit

class DescriptionWeaponView: UIView {
    
    lazy var descriptionIV = UIImageView()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(descriptionIV)
        self.addSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h = self.bounds.height
        let w = self.bounds.width
        
        descriptionIV.frame = CGRect(x: 0, y: 0, width: w, height: h / 3)
        descriptionLabel.frame = CGRect(x: 0, y: h / 3 + 1, width: w, height: 2 * h / 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
