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
            articleTitleLabel.apply(style: .Headline1)

            articleAbstractLabel.text = article.abstractCleanedHTML
            articleAbstractLabel.apply(style: .Text1)

            authorDateLabel.text = article.byline
            authorDateLabel.apply(style: .Text2)
            
            if let photoURL = article.abstractPhotoURL,
                let url = URL(string: photoURL) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.abstractImage?.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
}
