//
//  CoolDownNotificationView.swift
//  IRLKiller
//
//  Created by Daniil Korolev on 22.12.2019.
//  Copyright © 2019 Aleksandr Vorobev. All rights reserved.
//

import UIKit
import Lottie

class CoolDownNotificationView: UIView {
    
    let animationView = AnimationView(name: "cooldown")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(animationView)
        setupAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = self.bounds
    }
    
    private func setupAnimation() {
        animationView.animationSpeed = 1.0
        animationView.loopMode = .loop
        animationView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
