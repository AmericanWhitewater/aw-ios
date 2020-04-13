import UIKit
import WebKit

class SingleArticleViewController: UIViewController, WKNavigationDelegate  {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleAuthorDateLabel: UILabel!
    
    var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let errorMessage = "<h2>An Unknown Error Occurred. Please check your connection and try again</h2>"
        
        // Do any additional setup after loading the view.
        if let article = selectedArticle {
            
            if let title = article.title {
                articleTitleLabel.text = title
            } else {
                articleTitleLabel.text = ""
            }
            
            if let author = article.author {
                articleAuthorDateLabel.text = "By: \(author)"
            } else {
                articleAuthorDateLabel.text = ""
            }
            
            if let postedDate = article.posted {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd hh:mm:ssZ"
                let date = dateFormatter.date(from: postedDate)
                let simpleDateFormat = DateFormatter()
                simpleDateFormat.dateFormat = "MMM dd, yyyy"
                
                if date != nil {
                    let postedDatePretty = simpleDateFormat.string(from: date!)
                    if articleAuthorDateLabel.text!.count > 0 {
                        articleAuthorDateLabel.text = articleAuthorDateLabel.text! + " - \(postedDatePretty)"
                    } else {
                        articleAuthorDateLabel.text = postedDatePretty
                    }
                }
            } else {
                articleAuthorDateLabel.text = ""
            }
            
            if let content = article.contents {
                var headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=2.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
                headerString.append(content)
                webView.loadHTMLString(headerString, baseURL: nil)
            } else {
                webView.loadHTMLString(errorMessage, baseURL: nil)
            }
        } else {
            webView.loadHTMLString(errorMessage, baseURL: nil)
        }
    }    
}