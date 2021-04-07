
import Foundation

enum ParameterValidationError: Error {
    case isEmpty, invalidParam
    
    init?(param: String?) {
        guard let param = param else {
            self = .isEmpty
            return
        }
        let okText = "[^a-zA-Z0-9]"
        
        // 使えない文字を使っている場合
        if param.range(of: okText, options: .regularExpression, range: nil, locale: nil) != nil {
            self = .invalidParam
            return
        }
        // エラーが無ければnilを返す
        return nil
    }
    
    var message: String {
        switch self {
        case .isEmpty:
            return "入力不備があります"

        case .invalidParam:
            return "英数字しか使えません"
        }
    }
}
