
import UIKit

extension UIActivityIndicatorView {
    func animation(isStart: Bool) {
        DispatchQueue.main.async {
            if isStart {
                self.startAnimating()
                
            }else {
                self.stopAnimating()
            }
        }
    }
}
