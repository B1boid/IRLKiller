import UIKit
import Lottie

class LoadingAnimationView: UIView {
    
    private let loadingAnimation = AnimationView(name: "loading")

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.8656491637, green: 0.2913296521, blue: 0.3646270633, alpha: 1)
        setupLoadingAnimation()
        self.addSubview(loadingAnimation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoadingAnimation() {
        loadingAnimation.loopMode = .loop
        loadingAnimation.animationSpeed = 1.3
        loadingAnimation.play()
    }
    
    func startLoadingAnimation() {
        loadingAnimation.play()
    }
    
    func stopLoadingAnimation() {
        loadingAnimation.stop()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingAnimation.frame = self.bounds
    }
}
