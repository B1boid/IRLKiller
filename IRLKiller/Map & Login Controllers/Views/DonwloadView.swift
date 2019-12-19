//
//  DonwloadView.swift
//  IRLKiller
//
//  Created by Daniil Korolev on 12.12.2019.
//  Copyright © 2019 Aleksandr Vorobev. All rights reserved.
//

import UIKit

class DonwloadView: UIView {
    
    var circleDownloadLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    
    let percantageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Hello try if it works"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(percantageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDownloadCircle(center: CGPoint, radius: CGFloat, mainColor: CGColor, trackColor: CGColor) {
        circleDownloadLayer = CAShapeLayer.createDownloadCircle(center: center, radius: radius, color: mainColor)
        trackLayer = CAShapeLayer.createDownloadCircle(center: center, radius: radius, color: trackColor)
        
        let squareSide = radius / sqrt(2)
        percantageLabel.frame = CGRect(x: center.x - squareSide, y: center.y - squareSide, width: radius, height: radius)
        percantageLabel.setNeedsLayout()
        
        print("Added")
        print("Added")
        print("Added")
        print("Added")
        print("Added")
        print("Added")
        print("Added")
        
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(circleDownloadLayer)
    }
    
    func animateDownload(with duration: CFTimeInterval) {
        guard let layer = circleDownloadLayer else {
            assertionFailure("Init download layer first")
            return
        }
   
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))

        // View animations
        var oldDate = TimeConverter.convertToUTC(in: .second)
        var percentage: UInt = 0
        UIView.animate(withDuration: duration) {
            let timeInSec = TimeConverter.showDiff(oldDate: oldDate, in: .second)
            percentage += timeInSec
            self.percantageLabel.text = "\(Int(Double(percentage) / duration * 100))%"
            oldDate = TimeConverter.convertToUTC(in: .second)
        }
        CAShapeLayer.animateDownloadProcess(layer, duration: duration)
        CATransaction.commit()
    }
}

extension CAShapeLayer {
    
    fileprivate static func animateDownloadProcess(_ circleLayer: CAShapeLayer, duration: CFTimeInterval) {
        let downloadAnimation = CABasicAnimation(keyPath: "strokeEnd")
        downloadAnimation.toValue = 1
        downloadAnimation.duration = duration
        downloadAnimation.fillMode = .forwards
        downloadAnimation.isRemovedOnCompletion = false
        
        circleLayer.strokeEnd = 0
        circleLayer.add(downloadAnimation, forKey: "downloadAnimation")
    }
    
    class func createDownloadCircle(center: CGPoint, radius: CGFloat, color: CGColor, startAngle: CGFloat = -.pi / 2) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        let endAngle: CGFloat = 2 * .pi - startAngle
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.strokeColor = color
        circleLayer.path = circlePath.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 10
        circleLayer.lineCap = .round
        
        return circleLayer
    }
}

