import UIKit
import Lottie

class LoadingAnimationViewController: UIViewController {
    
    let animationView = AnimationView(name: "loading-map")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationView)
        view.backgroundColor = .black
        setupAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        animationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animationView.stop()
    }
    
    private func setupAnimation() {
        animationView.animationSpeed = 1
        animationView.loopMode = .loop
    }
}
