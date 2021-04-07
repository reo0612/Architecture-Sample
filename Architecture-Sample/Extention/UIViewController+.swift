
import UIKit

extension UIViewController {
    func show(next: UIViewController, complition: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let nav = self.navigationController {
                nav.pushViewController(next, animated: true)
                
            }else {
                self.present(next, animated: true, completion: complition)
            }
        }
    }
}
