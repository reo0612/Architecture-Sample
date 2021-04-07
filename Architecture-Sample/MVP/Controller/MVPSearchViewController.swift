
import UIKit

// Viewに関すること以外書かない
// ifやforといった制御が入ることはないはず

final class MVPSearchViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: TableViewCell.className, bundle: nil), forCellReuseIdentifier: TableViewCell.className)
        }
    }
    @IBOutlet weak private var indicator: UIActivityIndicatorView!
    
    private var searchBar = UISearchBar()

    // VCのインスタンス作成後にPresenterInputProtocolに準拠するもの(ここではMVPSearchPresenterを登録)
    // 画面遷移クラス(Router)でVCとPresenterを繋げてあげる
    private var input: MVPSearchPresenterInput!
    func inject(input: MVPSearchPresenterInput) {
        // このinputがpresenterのこと
        self.input = input
    }
    
    // 理想としてはこのようにinitを持ちたい
    // しかし、インスタンスを作るときにどっちも欲しがる形になってしまうのでinjectメソッドを用意している
//    init(presenter: MVPSearchPresenter) {
//        self.input = presenter
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
}

extension MVPSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // presenterにAPI通信を任せる
        input.search(param: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

extension MVPSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // presenterにセルの数を問い合わせている
        input.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.className, for: indexPath) as! TableViewCell
        // i番目のModelをpresenterから貰うように問い合わせている
        let githubModel = input.item(index: indexPath.item)
        // Modelを取得したらViewに渡す
        cell.configure(githubModel: githubModel)
        return cell
    }
}

extension MVPSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 何番目のセルがタップされましたよーをpresenterに伝える
        input.didSelect(index: indexPath.row)
    }
}

// presenterから送られてくる通知ごとに何をするかをVCで記載する
// MVPSearchPresenterOutputに準拠しないと処理できない
extension MVPSearchViewController: MVPSearchPresenterOutput {
    func update(loading: Bool) {
        indicator.animation(isStart: loading)
    }
    
    // ここでは引数のgithubModelsを使っていないがPresenter側からしたら、受け取る側がModelを使うか使わないかは関係ない
    // なのでPresenterはModelが更新されたので通知しているだけ
    func update(githubModels: [GithubModel]) {
        DispatchQueue.main.async {
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }
    }
    
    func validation(error: ParameterValidationError) {
        Alert.okAlert(vc: self, title: error.message, message: "")
    }
    
    func get(error: Error) {
        Alert.okAlert(vc: self, title: error.localizedDescription, message: "")
    }
    
    func showWeb(url: URL) {
        Router.showWeb(url: url, from: self)
    }
}
