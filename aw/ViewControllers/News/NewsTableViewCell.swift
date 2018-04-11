import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAbstractLabel: UILabel!
    @IBOutlet weak var authorDateLabel: UILabel!
    @IBOutlet weak var abstractImage: UIImageView!

    var article: Article?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update() {
        if let article = article {
            articleTitleLabel.text = article.title
            articleAbstractLabel.text = article.abstractCleanedHTML
            authorDateLabel.text = article.byline
            if let photoURL = article.abstractPhotoURL,
                let url = URL(string: photoURL),
                let data = try? Data(contentsOf: url) {
                abstractImage?.image = UIImage(data: data)
            }
        }
    }

}
