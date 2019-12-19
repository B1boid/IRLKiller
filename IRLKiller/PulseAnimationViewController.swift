import UIKit

class PulseAnimationViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pulsatingView = PulsatingView(
            frame: view.bounds,
            radius: view.bounds.midX / 2,
            circleCenter: CGPoint(x: view.bounds.midX, y: view.bounds.midY),
            strokeColor: UIColor.outlineStrokeColor.cgColor,
            pulseColor: UIColor.pulsatingFillColor.cgColor
        )
        
        print(view.frame)
        pulsatingView.backgroundColor = UIColor.downloadViewBackgroundColor
        view.addSubview(pulsatingView)
        pulsatingView.startPulseAnimation(onePulseDuration: 1)
    }
}
