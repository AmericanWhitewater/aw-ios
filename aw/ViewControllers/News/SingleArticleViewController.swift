import UIKit

class SingleArticleViewController: UIViewController {
    var article: Article?
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SingleArticleViewController {
    func initialize() {
        updateContent()

        let shareIcon = UIBarButtonItem(
            image: UIImage(named: "share"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped))

        self.navigationItem.rightBarButtonItem = shareIcon

        titleLabel.apply(style: FontStyle.Headline1)
        bylineLabel.apply(style: FontStyle.Text2)
    }

    @objc func shareButtonTapped(_ sender: Any) {
        guard let article = article,
            let title = article.title,
            let url = article.url else { return }
        let activityController = UIActivityViewController(activityItems: [title, url], applicationActivities: nil)

        if let sender = sender as? UIView {
            activityController.popoverPresentationController?.sourceView = sender
        }
        present(activityController, animated: true, completion: nil)
    }

    func updateContent() {
        if let article = article {
            titleLabel.text = article.title
            bylineLabel.text = article.byline

            if let imageURL = article.abstractPhotoURL {
                articleImage.loadFromUrlAsync(urlString: imageURL)
            }

            if let html = article.contents {
                bodyLabel.attributedText = html.htmlToAttributedString
            }
        }
    }
}
