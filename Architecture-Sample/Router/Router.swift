
import UIKit
import SafariServices

final class Router {
    static func showRoot(window: UIWindow) {
        let rootVC = UIStoryboard.rootViewController
        let navRootVC = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navRootVC
        window.makeKeyAndVisible()
    }
    static func showWeb(url: URL, from: UIViewController) {
        let safariVC = SFSafariViewController(url: url)
        from.present(safariVC, animated: true, completion: nil)
    }
    // MVC用
    static func showMVCSearch(from: UIViewController) {
        let mvcSearchVC = UIStoryboard.mvcSearchViewController
        from.show(next: mvcSearchVC)
    }
    
    // MVP用
    static func showMVPSearch(from: UIViewController) {
        let mvpSearchVC = UIStoryboard.mvpSearchViewController
        // ここでPresenterと繋げる
        // PresenterとVCが参照しあうのでどちらかをweakにしないといけない
        let presenter = MVPSearchPresenter(output: mvpSearchVC)
        mvpSearchVC.inject(input: presenter)
        from.show(next: mvpSearchVC)
    }
}
