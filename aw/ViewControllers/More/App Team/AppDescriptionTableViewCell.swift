import UIKit

class AppDescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: "OpenSans", size: 19)
        descriptionLabel.apply(style: .Text1)
    }
}
