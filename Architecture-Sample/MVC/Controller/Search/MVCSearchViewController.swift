
import UIKit

final class MVCSearchViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: TableViewCell.className, bundle: nil), forCellReuseIdentifier: TableViewCell.className)
        }
    }
    @IBOutlet weak private var indicator: UIActivityIndicatorView!
    
    private let searchBar = UISearchBar()
    private var githubModels: [GithubModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
}

extension MVCSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let githubUrl = URL(string: githubModels[indexPath.row].urlStr) else {
            Alert.okAlert(vc: self, title: AppError.getApiData.domain, message: "")
            return
        }
        Router.showWeb(url: githubUrl, from: self)
    }
}

extension MVCSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        githubModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.className, for: indexPath) as! TableViewCell
        let githubModel = githubModels[indexPath.row]
        cell.configure(githubModel: githubModel)
        return cell
    }
}

extension MVCSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let validationErrorMessage = ParameterValidationError(param: searchBar.text)?.message {
            Alert.okAlert(vc: self, title: validationErrorMessage, message: "")
            return
        }
        guard let searchText = searchBar.text else { return }
        
        indicator.animation(isStart: true)
        
        GithubAPI.shared.get(searchText: searchText) { (result) in
            switch result {
            case .success(let githubModels):
                self.indicator.animation(isStart: false)
                
                if githubModels.isEmpty {
                    Alert.okAlert(vc: self, title: AppError.emptyApiResponce.domain, message: "")
                    return
                }
                self.githubModels = githubModels
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    searchBar.resignFirstResponder()
                    searchBar.text = ""
                }
                
            case .failure(let error):
                self.indicator.animation(isStart: false)
                Alert.okAlert(vc: self, title: error.localizedDescription, message: "")
            }
        }
    }
}
