
import UIKit

final class TableViewCell: UITableViewCell {
    
    static var className: String { String(describing: TableViewCell.self) }
    
    @IBOutlet weak private var label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(githubModel: GithubModel) {
        label.text = githubModel.fullName
    }
}
