import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAbstractLabel: UILabel!
    @IBOutlet weak var authorDateLabel: UILabel!
    @IBOutlet weak var abstractImage: UIImageView!

    var article: Article?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleTitleLabel.apply(style: .Headline1)
        articleAbstractLabel.apply(style: .Text1)
        authorDateLabel.apply(style: .Text2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func update() {
        if let article = article {
            articleTitleLabel.text = article.title
            articleAbstractLabel.text = article.abstractCleanedHTML
            authorDateLabel.text = article.byline
            
            if let photoURL = article.abstractPhotoURL {
                self.abstractImage?.image = nil
                self.abstractImage?.loadFromUrlAsync(urlString: photoURL)
            }
        }
    }
    
}
