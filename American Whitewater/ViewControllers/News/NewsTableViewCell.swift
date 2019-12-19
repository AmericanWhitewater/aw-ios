import UIKit

class NewsTableViewCell: UITableViewCell {

    /*
     This represents the cell designed in the Interface Builder view
    */
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAuthorAndDateLabel: UILabel!
    @IBOutlet weak var articleAbstractLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
