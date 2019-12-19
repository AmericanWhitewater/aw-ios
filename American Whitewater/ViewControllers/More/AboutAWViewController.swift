import UIKit
import WebKit

class AboutAWViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    
    @IBOutlet weak var aboutSegmentControl: UISegmentedControl!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        loadAboutPage(index: aboutSegmentControl.selectedSegmentIndex)
    }
    
    @IBAction func aboutSegmentChanged(_ segmentControl: UISegmentedControl) {
        self.loadAboutPage(index: segmentControl.selectedSegmentIndex)
    }
  
    func loadAboutPage(index: Int) {
        
        var urlString = ""
        
        switch index {
            case 0:
                urlString = "https://www.americanwhitewater.org/content/Wiki/aw:about/"
            case 1:
                urlString = "https://www.americanwhitewater.org/content/Stewardship/view/"
            case 2:
                urlString = "https://www.americanwhitewater.org/content/Wiki/aw:giving/"
            default:
                urlString = "https://www.americanwhitewater.org/content/Wiki/aw:about/"
        }
        
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
        webView.load(URLRequest(url: URL(string: urlString)!))
    }
    
    // MARK: - WKWebView Delegates
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finished loading")
        loadingIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicatorView.stopAnimating()
    }
}
