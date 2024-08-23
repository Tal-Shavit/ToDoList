
import Foundation
import UIKit
import Lottie

class LottieController: UIViewController  {
    
    var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        animationView = LottieAnimationView(name:"Animation - 1724176978489")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .playOnce
        
        if let animationView = animationView{
            view.addSubview(animationView)
            animationView.play{(finished) in
                self.openNextScreen()
            }
        }
    }
    
    private func openNextScreen(){
        if let navigationController = self.navigationController{
            let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            navigationController.pushViewController(loginViewController, animated: true)
        }
    }
}
