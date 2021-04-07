
import UIKit

final class Alert {
    static func okAlert(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil, complition: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let okAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            okAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
            vc.present(okAlertVC, animated: true, completion: complition)
        }
    }
}
