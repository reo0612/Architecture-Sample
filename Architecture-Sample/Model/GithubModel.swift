
import Foundation

struct GithubModel: Codable {
    let fullName: String
    var urlStr: String { "https://github.com/\(fullName)" }
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
}

struct APIResponce: Codable {
    let items: [GithubModel]
}
