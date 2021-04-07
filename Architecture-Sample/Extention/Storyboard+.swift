
import UIKit

extension UIStoryboard {
    static var rootViewController: RootViewController {
        UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() as! RootViewController
    }
    
    // MVC用
    static var mvcSearchViewController: MVCSearchViewController {
        UIStoryboard(name: "MVCSearch", bundle: nil).instantiateInitialViewController() as! MVCSearchViewController
    }
    
    // MVP用
    static var mvpSearchViewController: MVPSearchViewController {
        UIStoryboard(name: "MVPSearch", bundle: nil).instantiateInitialViewController() as! MVPSearchViewController
    }
}
