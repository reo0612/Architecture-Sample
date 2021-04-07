
import Foundation

enum AppError: Int {
    case decodeApi
    case emptyApiResponce
    case getApiData
    
    var domain: String {
        switch self {
        case .decodeApi:
            return "デコードできませんでした"
            
        case .emptyApiResponce:
            return "検索結果がありませんでした"
            
        case .getApiData:
            return "値が取得できませんでした"
        }
    }
    var error: NSError {
        NSError(domain: domain, code: rawValue, userInfo: nil)
    }
}
