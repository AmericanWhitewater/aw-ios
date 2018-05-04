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
            articleTitleLabel.font = FontStyles.headline1.font
            articleTitleLabel.textColor = FontStyles.headline1.color

            articleAbstractLabel.text = article.abstractCleanedHTML
            articleAbstractLabel.font = FontStyles.text1.font
            articleAbstractLabel.textColor = FontStyles.text1.color

            authorDateLabel.text = article.byline
            authorDateLabel.font = FontStyles.text2.font
            authorDateLabel.textColor = FontStyles.text2.color
            
            if let photoURL = article.abstractPhotoURL,
                let url = URL(string: photoURL),
                let data = try? Data(contentsOf: url) {
                abstractImage?.image = UIImage(data: data)
            }
        }
    }

}
