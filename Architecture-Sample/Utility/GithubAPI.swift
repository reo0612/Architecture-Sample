
import Foundation

protocol GithubAPIProtocol: AnyObject {
    func get(searchText: String, complition: ((Result<[GithubModel], Error>) -> Void)?)
}

final class GithubAPI: GithubAPIProtocol {
    static let shared = GithubAPI()
    private init() {}
    
    func get(searchText: String, complition: ((Result<[GithubModel], Error>) -> Void)? = nil) {
        let apiUrl = URL(string: "https://api.github.com/search/repositories?q=\(searchText)")!
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: apiUrl) { (data, responce, error) in
            if let error = error {
                complition?(.failure(error))
                return
            }
            guard
                let data = data,
                let decodeData = try? JSONDecoder().decode(APIResponce.self, from: data) else {
                complition?(.failure(AppError.decodeApi.error))
                return
            }
            let githubModels = decodeData.items
            complition?(.success(githubModels))
        }
        task.resume()
    }
}
