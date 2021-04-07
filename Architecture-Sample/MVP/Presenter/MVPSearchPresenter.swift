
import Foundation

// PresenterはInput・outputする相手は知らないし関係ない
// ModelやUtility(API)に依存している
// Controllerにも依存してるが、protocolなので依存度は弱い状態である

// ここで行うのは単純な処理のみ

// 入力に関するプロトコル
// VCから送られてくる
protocol MVPSearchPresenterInput {
    var numberOfItems: Int { get }
    func item(index: Int) -> GithubModel
    func search(param: String?)
    func didSelect(index: Int)
}

// 出力に関するプロトコル
// VCに結果を渡す
protocol MVPSearchPresenterOutput: AnyObject {
    func update(loading: Bool)
    func update(githubModels: [GithubModel])
    func validation(error: ParameterValidationError)
    func get(error: Error)
    func showWeb(url: URL)
}

final class MVPSearchPresenter {
    // VCとPresenterが参照し合い循環参照が起きるためweakキーワードを付ける
    private weak var output: MVPSearchPresenterOutput! // VCのこと
    private var api: GithubAPIProtocol!
    // 状態をここで保持する
    private var githubModels: [GithubModel]
    
    init(output: MVPSearchPresenterOutput, api: GithubAPIProtocol = GithubAPI.shared) {
        // このoutputがVCのこと
        self.output = output
        self.api = api
        self.githubModels = []
    }
}

// Presenterはinputのプロトコルに準拠する
extension MVPSearchPresenter: MVPSearchPresenterInput {
    var numberOfItems: Int {
        githubModels.count
    }
    
    func item(index: Int) -> GithubModel {
        githubModels[index]
    }
    
    func search(param: String?) {
        if let validationError = ParameterValidationError(param: param) {
            output.validation(error: validationError)
            return
        }
        guard let searchText = param else { return }
        
        // output(VC側に何をするかを任せる)
        output.update(loading: true)
        // PresenterではAPIを叩くだけ
        self.api.get(searchText: searchText) {[weak self] (result) in
            guard let self = self else{ return }
            switch result {
            case .success(let githubModels):
                self.output.update(loading: false)
                
                if githubModels.isEmpty {
                    self.output.get(error: AppError.emptyApiResponce.error)
                    return
                }
                // ここでModelを取得(状態保持)
                self.githubModels = githubModels
                // output(VC側に任せる)
                self.output.update(githubModels: githubModels)
                
            case .failure(let error):
                self.output.update(loading: false)
                // output(VC側に任せる)
                self.output.get(error: error)
            }
        }
    }
    
    func didSelect(index: Int) {
        guard let githubUrl = URL(string: githubModels[index].urlStr) else {
            output.get(error: AppError.getApiData.error)
            return
        }
        output.showWeb(url: githubUrl)
    }
}
