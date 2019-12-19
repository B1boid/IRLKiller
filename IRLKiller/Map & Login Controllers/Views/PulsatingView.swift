//
//  DonwloadView.swift
//  IRLKiller
//
//  Created by Daniil Korolev on 12.12.2019.
//  Copyright © 2019 Aleksandr Vorobev. All rights reserved.
//

import UIKit

class PulsatingView: UIView {
    
    var circleLayer: CAShapeLayer!
    var pulseLayer: CAShapeLayer!
    
    var radius: CGFloat!
    var circleCenter: CGPoint!
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Find your position"
        label.textColor = .white
        return label
    }()

    init(frame: CGRect, radius: CGFloat, circleCenter: CGPoint, strokeColor: CGColor, pulseColor: CGColor) {
        super.init(frame: frame)
        self.radius = radius
        self.circleCenter = circleCenter
        self.addSubview(statusLabel)
        createDownloadCircle(center: center, radius: radius, strokeColor: strokeColor, pulseColor: pulseColor)
    }
    
    override func layoutSubviews() {
        let freeYSpace = circleCenter.y - radius * 2
        let freeXSpace = self.bounds.width
        let inset: CGFloat = 30
        
        statusLabel.font = UIFont.boldSystemFont(ofSize: 40)
        statusLabel.frame = CGRect(x: inset, y: inset, width: freeXSpace - 2 * inset, height: freeYSpace - 2 * inset)
        statusLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDownloadCircle(center: CGPoint, radius: CGFloat, strokeColor: CGColor, pulseColor: CGColor) {
        circleLayer = CAShapeLayer.createCircleShape(center: center, radius: radius, strokeColor: strokeColor)
        pulseLayer = CAShapeLayer.createCircleShape(center: center, radius: radius, strokeColor: UIColor.clear.cgColor)
        pulseLayer.fillColor = pulseColor
     
        self.layer.addSublayer(pulseLayer)
        self.layer.addSublayer(circleLayer)
        
    }
    
    func startPulseAnimation(onePulseDuration: CFTimeInterval) {
        CAShapeLayer.startPulsatingAnimation(circleLayer, fromValue: 1.4, toValue: 1.0, onePulseDuration: onePulseDuration)
        CAShapeLayer.startPulsatingAnimation(pulseLayer,  fromValue: 1.0, toValue: 1.4, onePulseDuration: onePulseDuration)
    }
}

extension CAShapeLayer {
    
    fileprivate static func startPulsatingAnimation( _ layer: CAShapeLayer, fromValue: CGFloat, toValue: CGFloat, onePulseDuration: CFTimeInterval) {
        let pulsatingAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        pulsatingAnimation.fromValue = fromValue
        pulsatingAnimation.toValue = toValue
        pulsatingAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulsatingAnimation.repeatCount = .infinity
        pulsatingAnimation.autoreverses = true
        pulsatingAnimation.duration = onePulseDuration
        
        layer.add(pulsatingAnimation, forKey: "pulsate")
    }
    
    class func createCircleShape(center: CGPoint, radius: CGFloat, strokeColor: CGColor, startAngle: CGFloat = 0) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        let endAngle: CGFloat = 2 * .pi - startAngle
        let circlePath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.strokeColor = strokeColor
        circleLayer.path = circlePath.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 20
        circleLayer.position = center
        circleLayer.lineCap = .round
        
        return circleLayer
    }
}

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    static let downloadViewBackgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
}
