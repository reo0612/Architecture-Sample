
import UIKit

final class RootViewController: UIViewController {
    
    @IBOutlet weak private var mvcButton: UIButton!
    @IBOutlet weak private var mvpButton: UIButton!
    
    private lazy var buttons: [UIButton] = [mvcButton, mvpButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons.forEach({
            $0.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        })
    }
}

private extension RootViewController {
    @objc
    func tapButton(_ sender: UIButton) {
        switch sender {
        case mvcButton:
            Router.showMVCSearch(from: self)
        
        case mvpButton:
            Router.showMVPSearch(from: self)
            
        default:
            break
        }
    }
    
}
